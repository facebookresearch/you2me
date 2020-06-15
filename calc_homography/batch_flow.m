% Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

% example script to generate the homographies
N = 1025;
root = 'data/';
subroot= 'synchronized/frames/11-hand2';
%

dir = strcat(root, subroot);
fd = fopen('getflow.sh', 'wt');
for n = 1 : N
    fprintf(fd, 'echo getflow %d\n', n);
    fprintf(fd, './myflow %s/imxx%d.jpg %s/imxx%d.jpg\n', dir, n+1, dir, n+2);
    fprintf(fd, 'mv dx.txt motion/dx%d.txt\n', n);
    fprintf(fd, 'mv dy.txt motion/dy%d.txt\n', n);
end
fclose(fd);