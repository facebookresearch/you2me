N = 250;
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
    xyz = load(sprintf('output/r%d.txt', n));
    xyz = reshape(xyz, 3, 25);
    f = figure('visible', 'off');
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
    
    filename = join(['poses/p', num2str(n), '.png'], '');
    saveas(f, filename);
end