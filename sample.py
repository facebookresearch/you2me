# Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

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


def load_openpose(video_path, openpose_path, seq_length):
	openpose = []
	for i in range(seq_length):
		with open(os.path.join(video_path, openpose_path, "imxx" + str(i+1) + "_keypoints.json"), 'r') as f:
			js = json.load(f)
			if ('people' not in js) or (len(js['people']) <= 0) or ('pose_keypoints_2d' not in js['people'][0]):
				pose2 = [0] * 75
			else:
				pose2 = js['people'][0]['pose_keypoints_2d']
		openpose.append(pose2)
	openpose = torch.Tensor(openpose)
	return openpose


def load_homography(video_path, homography_path, seq_length):
	homography = []
	h = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0] * 15;
	homography.append(h)
	for i in range(seq_length-1):
		file = open(os.path.join(video_path, homography_path, "h" + str(i) + ".txt"))
		h = file.read().split()
		h = map(float, h)
		homography.append(h)
	homography = torch.Tensor(homography)
	return homography


def load_video(video_path, seq_length, transform=None):
	images = []
	for i in range(seq_length):
		image = Image.open(os.path.join(video_path, "imxx" + str(i + 1) + ".jpg")).convert('RGB')
		if transform is not None:
			image = transform(image)
		images.append(image)

	images = torch.stack(images).unsqueeze(0)
	return images


def main(args):
	transform = transforms.Compose([
		transforms.Resize(args.crop_size),
		transforms.ToTensor(),
		transforms.Normalize((0.485, 0.456, 0.406),
			(0.229, 0.224, 0.225))])

	with open(args.vocab_path, 'rb') as f:
		vocab = pickle.load(f)

	upp_size, low_size = vocab.get_shapes()
	start = time.time()
	encoder = EncoderCNN(args.embed_size).eval()

	if args.upp:
		decoder = DecoderRNN(args.embed_size, args.hidden_size, upp_size+1, args.num_layers)
	elif args.low:
		decoder = DecoderRNN(args.embed_size, args.hidden_size, low_size+1, args.num_layers)
	else:
		print('Please specify upper/lower body model to test')
		exit(0)

	decoder.train(False)
	encoder = encoder.to(device)
	decoder = decoder.to(device)

	encoder.load_state_dict(torch.load(args.encoder_path))
	decoder.load_state_dict(torch.load(args.decoder_path))

	video = load_video(args.image_dir, args.seq_length, transform)
	video_tensor = video.to(device)
	feature = encoder(video_tensor)
	homography = load_homography(args.image_dir, args.h_dir, args.seq_length)
	openpose = load_openpose(args.image_dir, args.openpose_dir, args.seq_length)
	sampled_ids = decoder.sample(feature, homography, openpose)

	end = time.time()
	print "duration", (end-start)

	sampled_ids = sampled_ids[0].cpu().numpy()
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
	parser.add_argument('--vocab_path', type=str, required=True, help='path for vocabulary wrapper')
	parser.add_argument('--output', type=str, required=True, help='output directory to save the pose files to')
	parser.add_argument('--encoder_path', type=str, required=True, help='path for trained encoder')
	parser.add_argument('--decoder_path', type=str, required=True, help='path for trained decoder')

	parser.add_argument('--upp', action='store_true', help='set flag if training upper body model')
	parser.add_argument('--low', action='store_true', help='set flag if training lower body model')

	parser.add_argument('--image_dir', type=str, default='images/', help='directory for resized images')
	parser.add_argument('--h_dir', type=str, default='homographies/', help='directory for resized images')
	parser.add_argument('--openpose_dir', type=str, default='openpose/', help='directory for resized images')

	parser.add_argument('--embed_size', type=int , default=256, help='dimension of word embedding vectors')
	parser.add_argument('--hidden_size', type=int , default=512, help='dimension of lstm hidden states')
	parser.add_argument('--num_layers', type=int , default=2, help='number of layers in lstm')
	parser.add_argument('--seq_length', type=int, default=1025, help='length of the pose/video sequences')
	parser.add_argument('--crop_size', type=int, default=224 , help='size for randomly cropping images')

	args = parser.parse_args()
	main(args)
