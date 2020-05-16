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
	annotation = Annotation()
	categories = {"patty26":2304, #"patty26-fast", "patty26-single",
			"patty27":934, #"patty27-slow",
			"patty28":712, #"patty28-slow",
			"patty30":2063, #"patty30-fast", "patty30-single",
			"patty31":1410,
			"catch36":1656, 
			"catch37":2128, 
			#"catch38", 
			"catch39":3530, 
			"catch40":1360, 
			"catch41":1698, 
			"catch42":2258,
			"convo43":3010, 
			"convo46":3610, 
			"convo47":3980}
		
	for cat in categories:
		count = 0
		#for filename in os.listdir(base_dir + cat):
		#	if filename.endswith(".txt"):
		#		count += 1
		count = categories[cat]
		print(cat, ":", count)
		while (count - 512) > 0:
			annotation.anns.append((cat, count))
			count -= 32 # not 512 to do some overlapping
		annotation.anns.append((cat, 513))
	# print annotation.anns
	return annotation

def main(args):
	anns = build_annotation(args.base_dir)
	print ("num sequences:", len(anns))
	annotation_path = args.annotation_path
	with open(annotation_path, 'wb') as f:
		pickle.dump(anns, f)

if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--base_dir', type=str, 
		default='../../../capture_skeleton_and_align/matlab_scripts/data/',
		help='path to base dir for all captures')
	parser.add_argument('--annotation_path', type=str, 
		default='../vocab/annotation.pkl',
		help='path to base dir for all captures')
	args = parser.parse_args()
	main(args)
