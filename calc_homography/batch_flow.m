N = 2427;
root = '/media/evonne/EvoSamsungUSB/you2me/DATASET/cmu/';
subroot= '/synchronized/frames';
cat = '11-hand2';

dir = strcat(root, cat, subroot);
fd = fopen('getflow.sh', 'wt');
for n = 2262 : N
    n
    fprintf(fd, 'echo getflow %d\n', n);
    fprintf(fd, './myflow %s/imxx%d.jpg %s/imxx%d.jpg\n', dir, n+1, dir, n+2);
    fprintf(fd, 'mv dx.txt motion/dx%d.txt\n', n);
    fprintf(fd, 'mv dy.txt motion/dy%d.txt\n', n);
end
fclose(fd);