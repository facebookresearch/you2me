#!/bin/bash
#ffmpeg -r 20 -i poses/p%d.png -vcodec libx264 -vf scale=228:-1 -crf 15 output_vid.mp4
ffmpeg -r 20 -i ../sample/imxx%d.png -vcodec libx264 -s 1920x1080 -crf 15 sample_vid.mp4
