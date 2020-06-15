# Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

import argparse
import os
import pickle


class Annotation(object):
	""" Simple vocabulary wrapper """
	def __init__(self):
		self.anns = []


	def __len__(self):
		return len(self.anns)


	def addSequence(path, range):
		anns.append((path, range))


def build_annotation(base_dir):
	""" sample function to build the annotation wrapper: customize accordingly
		Note: We provide starter annotation file in 'vocab/'
	"""
	annotation = Annotation()
	categories = {"patty26":2304,
				  "patty27":934,
				  "patty28":712,
				  "patty30":2063,
				  "patty31":1410,
				  "catch36":1656, 
				  "catch37":2128,
				  "catch39":3530, 
				  "catch40":1360, 
				  "catch41":1698, 
				  "catch42":2258,
				  "convo43":3010, 
				  "convo46":3610, 
				  "convo47":3980}
		
	for cat in categories:
		count = 0
		count = categories[cat]
		while (count - 512) > 0:
			annotation.anns.append((cat, count))
			count -= 32
		annotation.anns.append((cat, 513))
	return annotation


def main(args):
	anns = build_annotation(args.base_dir)
	print ("num sequences:", len(anns))
	annotation_path = args.annotation_path
	with open(annotation_path, 'wb') as f:
		pickle.dump(anns, f)


if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--base_dir', type=str, required=True, help='path to base dir for all captures')
	parser.add_argument('--annotation_path', type=str, required=True, help='path to base dir for all captures')
	args = parser.parse_args()
	main(args)
