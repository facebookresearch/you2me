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
		"""
		Args:
			root: image and pose directory
			vocab: vocabulary wrapper
			transforms: image transformer
		"""
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
			image, pose, h, pose2 = getPair(imroot, hroot, oproot, path, vocab, i)
			if self.transform is not None:
				image = self.transform(image)
			poses.append(pose) # append the cluster id
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
	# merge images (tuple of 4D tensor to 5D <batch, seq, feat, width, height>)
	images = torch.stack(images, 0)
	# merge poses from tuple of (1D tensor to 2D <batch, seq>)
	lengths = [len(pose) for pose in poses]
	targets = torch.zeros(len(poses), max(lengths)).long()
	for i, pose in enumerate(poses):
		end = lengths[i]
		targets[i, :end] = pose[:end]

	# merge homographies from tuple of (3D tensor < batch, seq, 9>)
	homography = torch.stack(homography, 0)
	poses2 = torch.stack(poses2, 0)
	return images, targets, homography, poses2, lengths

""" helper method to get the image corresponding to the pair """
def getPair(imroot, hroot, oproot, path, vocab, index):
	if index <= 1:
		h = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0] * 15;
	else:
		file = open(hroot + "/" + path + "/h" + str(index - 2) + ".txt")
		h = file.read().split()
		h = map(float, h)

	with open(oproot + "/" + path + "/imxx" + str(index) + ".txt", 'r') as f:
		js = json.load(f)
		if ('people' not in js) or (len(js['people']) <= 0) or ('pose_keypoints_2d' not in js['people'][0]):
			pose2 = [0] * 75
		else:
			pose2 = js['people'][0]['pose_keypoints_2d']
	cluster = vocab.ids[path][index-1]
	path = path + "/imxx" + str(index) + ".jpg";
	image = Image.open(os.path.join(imroot, path)).convert('RGB')
	return image, cluster, h, pose2

def get_loader(annotation, imroot, hroot, oproot, vocab, transform, batch_size, shuffle, num_workers, seq_length):
	""" Returns torch.utils.data.DataLoader for custom pose dataset. """
	ds = PoseDataset(annotation=annotation, imroot=imroot, hroot=hroot, oproot=oproot, vocab=vocab, 
		seq_length=seq_length, transform=transform)
	data_loader = torch.utils.data.DataLoader(dataset=ds, batch_size=batch_size,
		shuffle=shuffle, num_workers=num_workers, collate_fn=collate_fn)
	return data_loader

def main(args):
	vocab = build_vocab(args.id_path, args.cluster_path)
	image, cluster, h, pose2 = getPair(args.imroot, args.hroot, args.oproot, "patty5", vocab, 2003)
	print pose2
	# print cluster
	# image.show()

if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--id_path', type=str, 
		default='../../../ego_pose/template/cluster/ids.txt', 
		help='path to cluster id of each pose/image')
	parser.add_argument('--cluster_path', type=str, 
		default='../../../ego_pose/template/cluster/cluster.txt', 
		help='path to annotation of id to cluster')
	parser.add_argument('--imroot', type=str, 
		default='../../../capture_skeleton_and_align/matlab_scripts/data/', 
		help='root folder to images')
	parser.add_argument('--hroot', type=str, 
		default='../../homography', 
		help='root folder to images')
	parser.add_argument('--oproot', type=str, 
		default='../../openpose/raw_pose', 
		help='root folder to images')
	args = parser.parse_args()
	main(args)
