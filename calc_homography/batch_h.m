N = 2736;
for n = 0 : N 
   n
   dx = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/10_/motion/dx%d.txt', n));
   dy = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/10_/motion/dy%d.txt', n));
   dx = dx(10:5:100-10,10:5:100-10);
   dy = dy(10:5:100-10,10:5:100-10);
   [sx,sy] = meshgrid(10:5:100-10,10:5:100-10);
   tx = sx + dx;
   ty = sy + dy;   
   H = geth(sx(:), sy(:), tx(:), ty(:));
   H = H/H(1,1);
%    dlmwrite(sprintf('../sample/homography/h%d.txt', n), H, ' '); % spec where to save homographies
    dlmwrite(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/10-hand1/features/homography/h%d.txt', n), H, ' ');
end

N = 3853;
for n = 0 : N 
   n
   dx = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/9_/motion/dx%d.txt', n));
   dy = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/9_/motion/dy%d.txt', n));
   dx = dx(10:5:100-10,10:5:100-10);
   dy = dy(10:5:100-10,10:5:100-10);
   [sx,sy] = meshgrid(10:5:100-10,10:5:100-10);
   tx = sx + dx;
   ty = sy + dy;   
   H = geth(sx(:), sy(:), tx(:), ty(:));
   H = H/H(1,1);
%    dlmwrite(sprintf('../sample/homography/h%d.txt', n), H, ' '); % spec where to save homographies
    dlmwrite(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/9-convo6/features/homography/h%d.txt', n), H, ' ');
end

N = 3733;
for n = 0 : N 
   n
   dx = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/3_/motion/dx%d.txt', n));
   dy = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/3_/motion/dy%d.txt', n));
   dx = dx(10:5:100-10,10:5:100-10);
   dy = dy(10:5:100-10,10:5:100-10);
   [sx,sy] = meshgrid(10:5:100-10,10:5:100-10);
   tx = sx + dx;
   ty = sy + dy;   
   H = geth(sx(:), sy(:), tx(:), ty(:));
   H = H/H(1,1);
%    dlmwrite(sprintf('../sample/homography/h%d.txt', n), H, ' '); % spec where to save homographies
    dlmwrite(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/3-catch3/features/homography/h%d.txt', n), H, ' ');
end

N = 3733;
for n = 2244 : N 
   n
   dx = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/12_/motion/dx%d.txt', n));
   dy = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/12_/motion/dy%d.txt', n));
   dx = dx(10:5:100-10,10:5:100-10);
   dy = dy(10:5:100-10,10:5:100-10);
   [sx,sy] = meshgrid(10:5:100-10,10:5:100-10);
   tx = sx + dx;
   ty = sy + dy;   
   H = geth(sx(:), sy(:), tx(:), ty(:));
   H = H/H(1,1);
%    dlmwrite(sprintf('../sample/homography/h%d.txt', n), H, ' '); % spec where to save homographies
    dlmwrite(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/12-hand3/features/homography/h%d.txt', n), H, ' ');
end

N = 3601;
for n = 2260 : N 
   n
   dx = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/11_/motion/dx%d.txt', n));
   dy = load(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/motion/11_/motion/dy%d.txt', n));
   dx = dx(10:5:100-10,10:5:100-10);
   dy = dy(10:5:100-10,10:5:100-10);
   [sx,sy] = meshgrid(10:5:100-10,10:5:100-10);
   tx = sx + dx;
   ty = sy + dy;   
   H = geth(sx(:), sy(:), tx(:), ty(:));
   H = H/H(1,1);
%    dlmwrite(sprintf('../sample/homography/h%d.txt', n), H, ' '); % spec where to save homographies
    dlmwrite(sprintf('/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/11-hand2/features/homography/h%d.txt', n), H, ' ');
end
