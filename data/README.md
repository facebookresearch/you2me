# You2Me Dataset

## Overview

The you2me dataset captures a variety of activities from a single chest mounted camera.

The activity categories are:

1. Hand games
2. Sports
3. Conversations
4. Tossing/Catching

There are 2 different capture methods: (1) Kinect, (2) Panoptic studio [Joo ICCV 2015]

## Download

To download each of the datasets, please run:

`wget http://dl.fbaipublicfiles.com/you2me/you2me_ds_release_kinect.tar && tar xf you2me_ds_release_kinect.tar`

`wget http://dl.fbaipublicfiles.com/you2me/you2me_ds_release_cmu.tar && tar xf you2me_ds_release_cmu.tar`


## Dataset Structure 

Within the kinect folder, you will find 24 video sequences each containing folders: 

```
+-- synchronized/
|	+-- frames/: image frames from GOPRO chestmounted ego-video capture extracted at 30 fps.  	
|	+-- gt-egopose/: ground truth 25 3D skeleton joints of the camera wearer captured by a Kinect.
|	+-- gt-interactee/: ground truth 25 3D skeleton joints of the interactee by a Kinect.
+-- features/
|	+-- homography/: preprocessed 15 frame homographies for the whole sequence
|	+-- openpose/output_json/: openpose results for each frame
```

Similarly, within the cmu folder, you will find 14 video sequences each containing folders:

```
+-- synchronized/
|	+-- frames/: image frames from GOPRO chestmounted ego-video capture extracted at 30 fps.
|	+-- gt-skeletons/: ground truth 19 3D skeleton joints of both the camera wearer and the interactee 
|                          captured by the Panoptic Studio dome, saved individually within a JSON.  
+-- features/
|	+-- homography/: preprocessed 15 frame homographies for the whole sequence
|	+-- openpose/output_json/: openpose results for each frame
```

Furthermore, we provide the raw GOPRO video along with the unprocessed kinect/panoptic studio skeleton files in the unprocessed/ directory. Note, these files have not been synchronized.


## Citation

If you find this dataset helpful, please consider citing us:

```
@article{ng2019you2me,
  title={You2Me: Inferring Body Pose in Egocentric Video via First and Second Person Interactions},
  author={Ng, Evonne and Xiang, Donglai and Joo, Hanbyul and Grauman, Kristen},
  journal={CVPR},
  year={2020}
}
```