# Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

import argparse
import os
import pickle

class Vocabulary(object):
	""" Simple vocabulary wrapper """
	def __init__(self):
		self.upp_poses = []
		self.upp_ids = {}
		self.low_poses = []
		self.low_ids = {}

	def get_shapes(self):
		return (len(self.upp_poses), len(self.low_poses))


def build_vocab(ids_upp, ids_low, cluster_upp, cluster_low):
	""" Sample function to build the vocabulary wrapper: customize accordingly
		Note: We provide starter vocab file in 'vocab/'
	"""
	vocab = Vocabulary()
	with open(ids_upp) as file:
		upp_ids = file.read()
		upp_ids = upp_ids[:-1]
	upp_ids = upp_ids.split('\n')
	upp_ids = map(int, upp_ids)

	with open(ids_low) as file:
		low_ids = file.read()
		low_ids = low_ids[:-1]
	low_ids = low_ids.split('\n')
	low_ids = map(int, low_ids)

	count = 0
	patty26 = upp_ids[count:count+2304] #2304
	vocab.upp_ids["patty26"] = patty26
	patty26 = low_ids[count:count+2304]
	vocab.low_ids["patty26"] = patty26
	count += 2304

	patty27 = upp_ids[count:count+934] #934
	vocab.upp_ids["patty27"] = patty27
	patty27 = low_ids[count:count+934] #934
	vocab.low_ids["patty27"] = patty27
	count += 934

	patty28 = upp_ids[count:count+712] #712
	vocab.upp_ids["patty28"] = patty28
	patty28 = low_ids[count:count+712] #712
	vocab.low_ids["patty28"] = patty28
	count += 712
	
	patty30 = upp_ids[count:count+2063] #2063
	vocab.upp_ids["patty30"] = patty30
	patty30 = low_ids[count:count+2063] #2063
	vocab.low_ids["patty30"] = patty30
	count += 2063
	
	patty31 = upp_ids[count:count+1410] #1410
	vocab.upp_ids["patty31"] = patty31
	patty31 = low_ids[count:count+1410] #1410
	vocab.low_ids["patty31"] = patty31
	count += 1410

	catch36 = upp_ids[count:count+1656] #1656
	vocab.upp_ids["catch36"] = catch36
	catch36 = low_ids[count:count+1656] #1656
	vocab.low_ids["catch36"] = catch36
	count += 1656

	catch37 = upp_ids[count:count+2128] #2128
	vocab.upp_ids["catch37"] = catch37
	catch37 = low_ids[count:count+2128] #2128
	vocab.low_ids["catch37"] = catch37
	count += 2128

	catch39 = upp_ids[count:count+3530] #3530
	vocab.upp_ids["catch39"] = catch39
	catch39 = low_ids[count:count+3530] #3530
	vocab.low_ids["catch39"] = catch39
	count += 3530

	catch40 = upp_ids[count:count+1360] #1360
	vocab.upp_ids["catch40"] = catch40
	catch40 = low_ids[count:count+1360] #1360
	vocab.low_ids["catch40"] = catch40
	count += 1360

	catch41 = upp_ids[count:count+1698] #1698
	vocab.upp_ids["catch41"] = catch41
	catch41 = low_ids[count:count+1698] #1698
	vocab.low_ids["catch41"] = catch41
	count += 1698

	catch42 = upp_ids[count:count+2258] #2258
	vocab.upp_ids["catch42"] = catch42
	catch42 = low_ids[count:count+2258] #2258
	vocab.low_ids["catch42"] = catch42
	count += 2258

	convo43 = upp_ids[count:count+3010] #3010
	vocab.upp_ids["convo43"] = convo43
	convo43 = low_ids[count:count+3010] #3010
	vocab.low_ids["convo43"] = convo43
	count += 3010

	convo46 = upp_ids[count:count+3610] #3610
	vocab.upp_ids["convo46"] = convo46
	convo46 = low_ids[count:count+3610] #3610
	vocab.low_ids["convo46"] = convo46
	count += 3610

	convo47 = upp_ids[count:count+3980] #3980
	vocab.upp_ids["convo47"] = convo47
	convo47 = low_ids[count:count+3980] #3980
	vocab.low_ids["convo47"] = convo47
	count += 3980

	with open(cluster_upp) as file:
		pose_list = file.read()
		pose_list = pose_list[:-1]
	pose_list = pose_list.split('\n')
	vocab.upp_poses = pose_list

	with open(cluster_low) as file:
		pose_list = file.read()
		pose_list = pose_list[:-1]
	pose_list = pose_list.split('\n')
	vocab.low_poses = pose_list

	print("Total number files:", count)
	return vocab


def main(args):
	vocab = build_vocab(args.id_path, args.cluster_path)
	vocab_path = args.vocab_path
	with open(vocab_path, 'wb') as f:
		pickle.dump(vocab, f)
	print("Total vocabulary size:{}".format(len(vocab)))
	print("Saved the vocab wrapper to '{}".format(vocab_path))


if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--id_path', type=str, required=True,
		help='path to cluster id of each pose/image')
	parser.add_argument('--cluster_path', type=str, required=True,
		help='path to annotation of id to cluster')
	parser.add_argument('--vocab_path', type=str, required=True,
		help='path to saving vocabulary wrapper')
	args = parser.parse_args()
	main(args)
