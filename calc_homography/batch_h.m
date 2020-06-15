% Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

% example script to generate the homographies
N = 1025;
%

for n = 0 : N
   dx = load(sprintf('motion/dx%d.txt', n));
   dy = load(sprintf('motion/dy%d.txt', n));
   dx = dx(10:5:100-10,10:5:100-10);
   dy = dy(10:5:100-10,10:5:100-10);
   [sx,sy] = meshgrid(10:5:100-10,10:5:100-10);
   tx = sx + dx;
   ty = sy + dy;   
   H = geth(sx(:), sy(:), tx(:), ty(:));
   H = H/H(1,1);
   dlmwrite(sprintf('homography/h%d.txt', n), H, ' ');
end