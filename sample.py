import torch
import numpy as np
import argparse 
import pickle
import time
import os
import json
from torchvision import transforms
from utils.build_vocab import Vocabulary
from utils.model import EncoderCNN, DecoderRNN
from PIL import Image

torch.manual_seed(7)
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

def load_openpose(video_path, seq_length):
	openpose = []
	for i in range(seq_length):
		with open(video_path + "/openpose_filled/imxx" + str(i+1) + "_keypoints.json", 'r') as f:
			js = json.load(f)
			if ('people' not in js) or (len(js['people']) <= 0) or ('pose_keypoints_2d' not in js['people'][0]):
				pose2 = [0] * 75
			else:
				pose2 = js['people'][0]['pose_keypoints_2d']
		openpose.append(pose2)
	openpose = torch.Tensor(openpose)
	return openpose

def load_homography(video_path, seq_length):
	homography = []
	h = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0] * 15;
	homography.append(h)
	for i in range(seq_length-1):
		file = open(video_path + "/homography/" + "h" + str(i) + ".txt")
		h = file.read().split()
		h = map(float, h)
		homography.append(h)
	homography = torch.Tensor(homography)
	return homography

def load_video(video_path, seq_length, transform=None):
	images = []
	for i in range(seq_length):
		name = "imxx" + str(i + 1) + ".jpg"
		image = Image.open(os.path.join(video_path, name)).convert('RGB')
		if transform is not None:
			image = transform(image)
		images.append(image)

	images = torch.stack(images).unsqueeze(0) # concat in column direction
	# expect images of size (1, 10, 3, 224, 224)
	return images

def main(args):
	# image preprocessing
	transform = transforms.Compose([
		transforms.Resize(args.crop_size),
		transforms.ToTensor(),
		transforms.Normalize((0.485, 0.456, 0.406),
			(0.229, 0.224, 0.225))])

	# load vocabulary wrapper
	with open(args.vocab_path, 'rb') as f:
		vocab = pickle.load(f)

	# build models
	encoder = EncoderCNN(args.embed_size).eval()
	decoder = DecoderRNN(args.embed_size, args.hidden_size, len(vocab)+1, args.num_layers)
	decoder.train(False)
	encoder = encoder.to(device)
	decoder = decoder.to(device)

	# load the trained model parameters
	encoder.load_state_dict(torch.load(args.encoder_path))
	decoder.load_state_dict(torch.load(args.decoder_path))

	# prepare an video clip
	video = load_video(args.video, args.seq_length, transform)
	video_tensor = video.to(device)

	# generate a pose sequence from the image
	start = time.time()
	feature = encoder(video_tensor)
	homography = load_homography(args.video, args.seq_length)
	openpose = load_openpose(args.video, args.seq_length)
	sampled_ids = decoder.sample(feature, homography, openpose)
	end = time.time()
	print "duration", (end-start)

	sampled_ids = sampled_ids[0].cpu().numpy()  #(1, seq_length) -> (seq_length)

	# convert pose_ids to poses
	sampled_poses = []
	for pose_id in sampled_ids:
		pose = vocab.poses[pose_id-1]
		sampled_poses.append(pose)
	print sampled_ids
	for i in range(0, len(sampled_poses)):
		path = args.output + 'r' + str(i+1) + '.txt'
		with open(path, 'w') as f:
			f.write(sampled_poses[i] + '\n')

if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--video', type=str, required=True, help='input video for generating caption')
	parser.add_argument('--output', type=str, default='output/', help='output directory to save the pose files to')
	parser.add_argument('--encoder_path', type=str, default='models/encoder-12-33.ckpt', help='path for trained encoder')
	parser.add_argument('--decoder_path', type=str, default='models/decoder-12-33.ckpt', help='path for trained decoder')
	parser.add_argument('--seq_length', type=int, default=1025, help='length of the pose/video sequences')
	parser.add_argument('--vocab_path', type=str, default='vocab/vocab.pkl', help='path for vocabulary wrapper')
	parser.add_argument('--crop_size', type=int, default=224 , help='size for randomly cropping images')

	# Model parameters (should be same as paramters in train.py)
	parser.add_argument('--embed_size', type=int , default=256, help='dimension of word embedding vectors')
	parser.add_argument('--hidden_size', type=int , default=512, help='dimension of lstm hidden states')
	parser.add_argument('--num_layers', type=int , default=2, help='number of layers in lstm')
	args = parser.parse_args()
	main(args)
