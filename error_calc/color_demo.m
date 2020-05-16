N = 1957;
openPose = false;

for n = 1 : N
    lime = [0, 255, 0] / 255;
    green = [0, 153, 0] / 255;
    orange = [255, 128, 0] / 255;
    red = [153, 0, 0] / 255;
    blue = [0, 0, 200] / 255;
    
    upper_left = [5, 6, 7, 8, 22, 23,];
    bottm_left = [13, 14, 15, 16];
    upper_right = [9, 10, 11, 12, 24, 25];
    bottm_right = [17, 18, 19, 20];
    center = [1, 2, 3, 4, 21];
    
    n
    xyz = load(sprintf('../vid2pose/output/r%d.txt', n));
%     xyz = load(sprintf('data/patty1/p%d.txt', n));
%     xyz = reshape(xyz, 3, 25);
    xyz = trans_pose(xyz);
    figure(1);
    clf;
    plot3(xyz(1,upper_left), xyz(3,upper_left), xyz(2,upper_left), ...
        '.', 'Color', green, 'markersize', 40);
    hold on;
    plot3(xyz(1,bottm_left), xyz(3,bottm_left), xyz(2,bottm_left), ...
        '.', 'Color', lime, 'markersize', 40);
    plot3(xyz(1,upper_right), xyz(3,upper_right), xyz(2,upper_right), ...
        '.', 'Color', red, 'markersize', 40);
    plot3(xyz(1,bottm_right), xyz(3,bottm_right), xyz(2,bottm_right), ...
        '.', 'Color', orange, 'markersize', 40);
    plot3(xyz(1,center), xyz(3,center), xyz(2,center), ...
        '.', 'Color', blue, 'markersize', 40);
    axis equal;
    drawnow;
%     ginput(1);
    
    % plot the image associated with pose
    if (openPose)
        figure(2);
        im = imread(sprintf('output_imgs/imxx%d_rendered.png', n));
        imshow(im);
    else
        figure(2);
        im = imread(sprintf('../sample/imxx%d.jpg', n));
        imshow(im);
    end
    pause(0.01);
end 
