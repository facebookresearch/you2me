N = 1025;
openPose = false;
clf;

red =   [225, 225, 225, 225, 225, 225, 225, 225];
green = [200, 180, 160, 140, 120, 100, 80];
% n =     [214, 218, 215, 226, 228, 230, 220];
n =     [220, 230, 228, 226, 215, 218, 214];

for i = 1:8
    val = jsondecode(fileread(sprintf('../sample_dir/convo2/openpose/imxx%d_keypoints.json', n(i))));
    op = val.('people');
    s = size(op);
    if (s(1) > 0)
       op = op.('pose_keypoints_2d'); 
       op = reshape(op, 3, 25);
       op = op([1:2], :);
       op = reshape(op, (2*25), 1); 
       opose(op, 2, red(i), green(i), 3);
    end
    pause(0.01);
%     ginput(1);
end 

function opose(xyz, fig, r, g, m)
    figure(fig);
    xyz = reshape(xyz, 2, 25);
    xyz(2,:) = -xyz(2,:);
    r = r/225;
    g = g/225;
    b = 0;
    a = 0.5;
    
    transpose = xyz(:,9) - zeros(2, 1);
    for i = 1:25
        xyz(:,i) = xyz(:,i) - transpose;
    end
    
    center = xyz(:,2);
    head = xyz(:,1);
    bottom = xyz(:,9);
    rightshoulder = xyz(:,6);
    rightelbow = xyz(:,7);
    righthand = xyz(:,8);
    righthip = xyz(:,13);
    rightknee = xyz(:,14);
    rightfoot = xyz(:,15);
    leftshoulder = xyz(:,3);
    leftelbow = xyz(:,4);
    lefthand = xyz(:,5);
    lefthip = xyz(:,10);
    leftknee = xyz(:,11);
    leftfoot = xyz(:,12);
    
    plot([head(1) center(1)], [head(2) center(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([bottom(1) center(1)], [bottom(2) center(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([rightshoulder(1) center(1)], [rightshoulder(2) center(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([leftshoulder(1) center(1)], [leftshoulder(2) center(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([leftshoulder(1) leftelbow(1)], [leftshoulder(2) leftelbow(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([lefthand(1) leftelbow(1)], [lefthand(2) leftelbow(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([rightshoulder(1) rightelbow(1)], [rightshoulder(2) rightelbow(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([righthand(1) rightelbow(1)], [righthand(2) rightelbow(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([bottom(1) lefthip(1)], [bottom(2) lefthip(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([bottom(1) righthip(1)], [bottom(2) righthip(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([leftknee(1) lefthip(1)], [leftknee(2) lefthip(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([leftknee(1) leftfoot(1)], [leftknee(2) leftfoot(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([rightknee(1) righthip(1)], [rightknee(2) righthip(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot([rightknee(1) rightfoot(1)], [rightknee(2) rightfoot(2)], 'color', [r,g,b,a], 'LineWidth', m);
    hold on;
    plot(xyz(1,:), xyz(2,:), '.', 'Color', [r,g,b,a], 'markersize', 25);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    axis equal;
    drawnow;
    
    pause(0.01)
end
