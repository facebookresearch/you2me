% Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

% example script to generate the homographies
dir = 'features/homography/11-hand2';
N = 1025;
%

for n = 1:(N - 2)
    f = [];
    for m = -14 : 0
        index = n + m
        if index < 0
            H = [1, 0, 0; 0, 1, 0; 0, 0, 1];
        else
            H = load(sprintf('homography/h%d.txt', index));
        end
        f = [f, H(:)'];
    end
    dlmwrite(sprintf('%s/h%d.txt', dir, n), f, ' '); 
end