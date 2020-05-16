N = 953;
for n = 1 : N
    n
    xyz = load(sprintf('../output/r%d.txt', n));
    xyz = reshape(xyz, 3, 25);
    plot3(xyz(1,:), xyz(3,:), xyz(2,:), '.', 'markersize', 40);
    axis equal
    drawnow;
    ginput(1);
end