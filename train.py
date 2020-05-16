import argparse
import torch
import torch.nn as nn
import numpy as np
import os
import pickle
from utils.data_loader import get_loader
from utils.build_vocab import Vocabulary
from utils.build_annotation import Annotation
from utils.model import EncoderCNN, DecoderRNN
from torch.nn.utils.rnn import pack_padded_sequence
from torchvision import transforms

# Device configuration
torch.manual_seed(7)
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

def main(args):
	# create model directory
	if not os.path.exists(args.model_path):
		os.makedirs(args.model_path)

	# image preprocessing
	transform = transforms.Compose([
		transforms.Resize(args.crop_size),
		transforms.ToTensor(),
		transforms.Normalize((0.485, 0.456, 0.406),
			(0.229, 0.224, 0.225))])

	# load vocab wrapper
	vocab = build_vocab(args.ids_upp, args.ids_low, args.cluster_upp, args.cluster_low)
	# with open(args.vocab_path, 'rb') as f:
	# 	vocab = pickle.load(f)
	print ("cluster sizes: ", len(vocab))

	with open(args.annotation_path, 'rb') as f:
		annotation = pickle.load(f)
	print ("annotations size:", len(annotation))
	
		# build data loader
	data_loader = get_loader(annotation, args.image_dir, args.h_dir, args.openpose_dir, vocab, transform, 
		args.batch_size, shuffle=True, num_workers=args.num_workers, seq_length=args.seq_length)

	# build the models
	upp_size, low_size = len(vocab)

	encoder = EncoderCNN(args.embed_size).to(device)
	decoder = DecoderRNN(args.embed_size, 
						 args.hidden_size, 
						 upp_size+1, 
						 low_size+1, 
						 args.num_layers).to(device)

	# loss and optimizer
	criterion = nn.CrossEntropyLoss()
	params = list(decoder.parameters()) + list(encoder.linear.parameters()) + list(encoder.bn.parameters())
	optimizer = torch.optim.Adam(params, lr=args.learning_rate)

	# train the models
	total_step = len(data_loader)
	print ("total iter", total_step)
	for epoch in range(args.num_epochs):
		for i, (images, poses, homography, poses2, lengths) in enumerate(data_loader):
			images = images.to(device)
			poses = poses.to(device)
			targets = pack_padded_sequence(poses, lengths, batch_first=True)[0]

			# forward, backward, optimize
			features = encoder(images)
			outputs = decoder(features, homography, poses2, lengths)
			# print ("outputs", outputs.shape, "targets", targets.shape)
			loss = criterion(outputs, targets)
			decoder.zero_grad()
			encoder.zero_grad()
			loss.backward()
			optimizer.step()

			# print log info
			if i % args.log_step == 0:
				print('Epoch [{}/{}], Step [{}/{}], Loss: {:.4f}, Perplexity: {:5.4f}'
					.format(epoch, args.num_epochs, i, total_step, loss.item(), np.exp(loss.item())))

			# save the model checkpoints
			if ((i+1) % args.save_step == 0) or (i == total_step-1):
				torch.save(decoder.state_dict(), os.path.join(args.model_path, 'decoder-{}-{}.ckpt'.format(epoch+1, i+1)))
				torch.save(encoder.state_dict(), os.path.join(args.model_path, 'encoder-{}-{}.ckpt'.format(epoch+1, i+1)))


if __name__== '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--model_path', type=str, default='models/' , help='path for saving trained models')
	# parser.add_argument('--vocab_path', type=str, default='vocab/vocab.pkl', help='path for vocabulary wrapper')
	parser.add_argument('--annotation_path', type=str, default='vocab/annotation.pkl', help='path for annotation wrapper')
	parser.add_argument('--image_dir', type=str, default='../../capture_skeleton_and_align/matlab_scripts/data/', help='directory for resized images')
	parser.add_argument('--h_dir', type=str, default='../homography', help='directory for resized images')
	parser.add_argument('--openpose_dir', type=str, default='../pose3d', help='directory for resized images')
	parser.add_argument('--seq_length', type=int, default=512, help='length of the pose/video sequences')
	parser.add_argument('--log_step', type=int , default=10, help='step size for prining log info')
	parser.add_argument('--save_step', type=int , default=5, help='step size for saving trained models')
	parser.add_argument('--crop_size', type=int, default=224 , help='size for randomly cropping images')

	# model parameters
	parser.add_argument('--embed_size', type=int , default=256, help='dimension of word embedding vectors')
	parser.add_argument('--hidden_size', type=int , default=512, help='dimension of lstm hidden states')
	parser.add_argument('--num_layers', type=int , default=2, help='number of layers in lstm')
	
	parser.add_argument('--num_epochs', type=int, default=20)
	parser.add_argument('--batch_size', type=int, default=32)
	parser.add_argument('--num_workers', type=int, default=4)
	parser.add_argument('--learning_rate', type=float, default=0.001)
	args = parser.parse_args()
	print(args)
	main(args)
