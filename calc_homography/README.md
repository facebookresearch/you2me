# Calculating Dynamic Motion Features via Homographies
Code borrowed and modified from [Hao Jiang](http://www.hao-jiang.net/code/egopose/ego_pose_code.tar.gz)

This is a mixture of opencv code and matlab. Follow the steps below to 
compute the optical flow and then the homography matricies. 
The code is only tested on Ubuntu.

## Steps to running code:
(1) Compile the opencv optical flow code. In a terminal, run `$ sh compile_mymotion.sh`

(2) Use `batch_flow.m` in matlab to generate a bash file to compute optical flows
    for a sequence of video frames. Change the directories to match your data locations.

(3) You now can run the bash file `$ sh getflow.sh` to get the dx and dy for each successive video
    frame. The result is stored in a directory "motion".

(4) Compute the homography between each two video frames using `batch_h.m`