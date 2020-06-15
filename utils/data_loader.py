# Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

import torch
import torchvision.transforms as transforms
import torch.utils.data as data
import random
import json

from PIL import Image
from build_vocab import Vocabulary
from build_vocab import build_vocab
from build_annotation import Annotation
import os
import argparse


class PoseDataset(data.Dataset):
	""" Pose custom dataset compatible with torch.utils.data.DataLoader. """
	def __init__(self, annotation, imroot, hroot, oproot, vocab, seq_length, transform=None):
		self.annotation = annotation
		self.imroot = imroot
		self.hroot = hroot
		self.oproot = oproot
		self.vocab = vocab
		self.transform = transform
		self.seq_length = seq_length


	def __getitem__(self, index):
		imroot = self.imroot
		hroot = self.hroot
		oproot = self.oproot
		vocab = self.vocab
		annotation = self.annotation
		path, end = annotation.anns[index]
		images = []
		poses = []
		poses2 = []
		homography = []
		for i in range (end-self.seq_length, end):
			image, upp_pose, low_pose, h, pose2 = getPair(imroot, hroot, oproot, path, vocab, i)
			if self.transform is not None:
				image = self.transform(image)
			poses.append((upp_pose, low_pose))
			images.append(image)
			homography.append(h)
			poses2.append(pose2)
		homography = torch.Tensor(homography)
		images = torch.stack(images)
		target = torch.Tensor(poses)
		poses2 = torch.Tensor(poses2)
		return images, target, homography, poses2


	def __len__(self):
		return len(self.annotation)


def collate_fn(data):
	""" Creates mini-batch tensors from the list of tuples (images, poses) """
	data.sort(key=lambda x: len(x[1]), reverse=True)
	images, poses, homography, poses2 = zip(*data)
	images = torch.stack(images, 0)
	lengths = [len(pose) for pose in poses]
	targets = torch.zeros(len(poses), max(lengths)).long()
	for i, pose in enumerate(poses):
		end = lengths[i]
		targets[i, :end] = pose[:end]

	homography = torch.stack(homography, 0)
	poses2 = torch.stack(poses2, 0)
	return images, targets, homography, poses2, lengths


def getPair(imroot, hroot, oproot, path, vocab, index):
	""" helper method to get the image corresponding to the pair """
	if index <= 1:
		h = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0] * 15;
	else:
		file = open(hroot + "/" + path + "/h" + str(index - 2) + ".txt")
		h = file.read().split()
		h = map(float, h)

	with open(oproot + "/" + path + "/imxx" + str(index) + ".txt", 'r') as f:
		js = json.loads(f.read())
		if ('joints' not in js) or (len(js['joints']) <= 0):
			pose2 = [0] * 48
		else:
			pose2 = js['joints']
	upp_cluster = vocab.upp_ids[path][index-1]
	low_cluster = vocab.low_ids[path][index-1]
	path = path + "/imxx" + str(index) + ".jpg";
	image = Image.open(os.path.join(imroot, path)).convert('RGB')
	return image, upp_cluster, low_cluster, h, pose2


def get_loader(annotation, imroot, hroot, oproot, vocab, transform, batch_size, shuffle, num_workers, seq_length):
	""" Returns torch.utils.data.DataLoader for custom pose dataset. """
	ds = PoseDataset(annotation=annotation, imroot=imroot, hroot=hroot, oproot=oproot, vocab=vocab, 
		seq_length=seq_length, transform=transform)
	data_loader = torch.utils.data.DataLoader(dataset=ds, batch_size=batch_size,
		shuffle=shuffle, num_workers=num_workers, collate_fn=collate_fn)
	return data_loader