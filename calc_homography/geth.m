% Copyright (c) Facebook, Inc. and its affiliates. All rights reserved.

function H  = geth(x1, y1, x2, y2)
   ax = [-x1, -y1, -ones(size(x1)), zeros(size(x1)), zeros(size(x1)),...
         zeros(size(x1)), x2.*x1, x2.*y1, x2];
   ay = [zeros(size(x1)), zeros(size(x1)),... 
         zeros(size(x1)), -x1, -y1, -ones(size(x1)), y2.*x1, y2.*y1, y2];
   A = [ax; ay];

   [U,S,V] = svd(A);
   H = reshape(V(:,9), 3, 3);
   H = H';

