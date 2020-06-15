% Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

N = 1025;
for n = 1 : N
    im = imread(sprintf('sample/imxx%d.jpg', n));
    im = imresize(im, [100, 100]);
    im = rgb2gray(im);
    im = im2double(im);
    im = fliplr(im);
    imwrite(im, sprintf('sample/im%d.jpg', n), 'quality', 100);
end