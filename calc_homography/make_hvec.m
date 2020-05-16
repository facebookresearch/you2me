root = '/media/evonne/EvoSamsungUSB/you2me/DATASET/kinect/';
subroot = '/features/homography';
cat = '16-convo59';

dir = strcat(root, cat, subroot);
for n = 0 : (2887 - 2)
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