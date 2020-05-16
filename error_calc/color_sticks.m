N = 1025;
openPose = false;
start = 0 + 50;
fin = 17 + 50;

prev = load(sprintf('../../vid2pose/output/r%d.txt', start-1));

for n = 100 : 1025
    n
    curr = load(sprintf('../../vid2pose/output/r%d.txt', n));
    curr = load(sprintf('../sample_dir/sample1/p%d.txt', n));
    ours = interp(prev, curr);
    sketch(ours, 1, 5, 40);
    ginput(1);
    saveas(gcf, sprintf('supp/ablation/still%d.jpg', n));
    
    gt = load(sprintf('../sample_dir/sample1/p%d.txt', n));
    sketch_color(gt, 2, 4, 30, 'red');
    prev = ours;
    saveas(gcf, sprintf('supp/ablation/gt%d.jpg', n));
    
    gt = load(sprintf('../sample_dir/sample3/p%d.txt', n));
    gt = load(sprintf('../../capture_skeleton_and_align/matlab_scripts/data/catch40/p%d.txt', n));
    sketch(gt, 2, 5, 40);
    saveas(gcf, sprintf('supp/s2/gt/gt%d.jpg', n));

%     val = jsondecode(fileread(sprintf('../sample_dir/sample1/openpose/imxx%d_keypoints.json', n)));
%     op = val.('people');
%     s = size(op);
%     if (s(1) > 0)
%        op = op.('pose_keypoints_2d'); 
%        op = reshape(op, 3, 25);
%        op = op([1:2], :);
%        op = reshape(op, (2*25), 1);
%        opose(op, 2, 'blue', 3);
%        saveas(gcf, sprintf('s2-op%d.jpg', n));
%     end
%     pause(0.01);
    ginput(1);
end

function ours = interp(prev, curr)
    v = curr - prev;
    ours = prev + (0.5 * v);
end

function sketch_color(xyz, fig, m, l, color)
    figure(fig);
    clf;
%     xyz = reshape(xyz, 3, 25);
    xyz = trans_pose(xyz);
    spinebase = xyz(:,1);
    plot3(xyz(1,1), xyz(3,1), xyz(2,1), '.', 'Color', color, 'markersize', l);
    hold on;
    
    spinemid = xyz(:,2);
    plot3(xyz(1,2), xyz(3,2), xyz(2,2), '.', 'Color', color, 'markersize', l);
    hold on;

    neck = xyz(:,3);
    plot3(xyz(1,3), xyz(3,3), xyz(2,3), '.', 'Color', color, 'markersize', l);
    hold on;

    head = xyz(:,4);
    plot3(xyz(1,4), xyz(3,4), xyz(2,4), '.', 'Color', color, 'markersize', l);
    hold on;

    shoulderleft = xyz(:,5);
    plot3(xyz(1,5), xyz(3,5), xyz(2,5), '.', 'Color', color, 'markersize', l);
    hold on;

    elbowleft = xyz(:,6);
    plot3(xyz(1,6), xyz(3,6), xyz(2,6), '.', 'Color', color, 'markersize', l);
    hold on;

    wristleft = xyz(:,7);
    plot3(xyz(1,7), xyz(3,7), xyz(2,7), '.', 'Color', color, 'markersize', l);
    hold on;

    handtipleft = xyz(:,8);
    plot3(xyz(1,8), xyz(3,8), xyz(2,8), '.', 'Color', color, 'markersize', l);
    hold on;

    shoulderright = xyz(:,9);
    plot3(xyz(1,9), xyz(3,9), xyz(2,9), '.', 'Color', color, 'markersize', l);
    hold on;

    elbowright = xyz(:,10);
    plot3(xyz(1,10), xyz(3,10), xyz(2,10), '.', 'Color', color, 'markersize', l);
    hold on;

    wristright = xyz(:,11);
    plot3(xyz(1,11), xyz(3,11), xyz(2,11), '.', 'Color', color, 'markersize', l);
    hold on;

    handtipright = xyz(:,12);
    plot3(xyz(1,12), xyz(3,12), xyz(2,12), '.', 'Color', color, 'markersize', l);
    hold on;

    hipleft = xyz(:,13);
    plot3(xyz(1,13), xyz(3,13), xyz(2,13), '.', 'Color', color, 'markersize', l);
    hold on;

    kneeleft = xyz(:,14);
    plot3(xyz(1,14), xyz(3,14), xyz(2,14), '.', 'Color', color, 'markersize', l);
    hold on;

    ankleleft = xyz(:,15);
    plot3(xyz(1,15), xyz(3,15), xyz(2,15), '.', 'Color', color, 'markersize', l);
    hold on;

    footleft = xyz(:,16);
    plot3(xyz(1,16), xyz(3,16), xyz(2,16), '.', 'Color', color, 'markersize', l);
    hold on;

    hipright = xyz(:,17);
    plot3(xyz(1,17), xyz(3,17), xyz(2,17), '.', 'Color', color, 'markersize', l);
    hold on;

    kneeright = xyz(:,18);
    plot3(xyz(1,18), xyz(3,18), xyz(2,18), '.', 'Color', color, 'markersize', l);
    hold on;

    ankleright = xyz(:,19);
    plot3(xyz(1,19), xyz(3,19), xyz(2,19), '.', 'Color', color, 'markersize', l);
    hold on;

    footright = xyz(:,20);
    plot3(xyz(1,20), xyz(3,20), xyz(2,20), '.', 'Color', color, 'markersize', l);
    hold on;

    spineshoulder = xyz(:,21);
    plot3(xyz(1,21), xyz(3,21), xyz(2,21), '.', 'Color', color, 'markersize', l);
    hold on;

    handtipleft = xyz(:,22);
    plot3(xyz(1,22), xyz(3,22), xyz(2,22), '.', 'Color', color, 'markersize', l);
    hold on;

    thumbleft = xyz(:,23);
    plot3(xyz(1,23), xyz(3,23), xyz(2,23), '.', 'Color', color, 'markersize', l);
    hold on;

    handtipright = xyz(:,24);
    plot3(xyz(1,24), xyz(3,24), xyz(2,24), '.', 'Color', color, 'markersize', l);
    hold on;

    thumbright = xyz(:,25);
    plot3(xyz(1,25), xyz(3,25), xyz(2,25), '.', 'Color', color, 'markersize', l);
    hold on;
    
    plot3([head(1) neck(1)], [head(3) neck(3)], [head(2) neck(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) neck(1)], [spineshoulder(3) neck(3)], [spineshoulder(2) neck(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([spinebase(1) hipright(1)], [spinebase(3) hipright(3)], [spinebase(2) hipright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([spinebase(1) hipleft(1)], [spinebase(3) hipleft(3)], [spinebase(2) hipleft(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([spinebase(1) spinemid(1)], [spinebase(3) spinemid(3)], [spinebase(2) spinemid(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) spinemid(1)], [spineshoulder(3) spinemid(3)], [spineshoulder(2) spinemid(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) shoulderright(1)], [spineshoulder(3) shoulderright(3)], [spineshoulder(2) shoulderright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([shoulderright(1) elbowright(1)], [shoulderright(3) elbowright(3)], [shoulderright(2) elbowright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([wristright(1) elbowright(1)], [wristright(3) elbowright(3)], [wristright(2) elbowright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([wristright(1) handtipright(1)], [wristright(3) handtipright(3)], [wristright(2) handtipright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) shoulderleft(1)], [spineshoulder(3) shoulderleft(3)], [spineshoulder(2) shoulderleft(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([shoulderleft(1) elbowleft(1)], [shoulderleft(3) elbowleft(3)], [shoulderleft(2) elbowleft(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([wristleft(1) elbowleft(1)], [wristleft(3) elbowleft(3)], [wristleft(2) elbowleft(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([wristleft(1) handtipleft(1)], [wristleft(3) handtipleft(3)], [wristleft(2) handtipleft(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([hipright(1) kneeright(1)], [hipright(3) kneeright(3)], [hipright(2) kneeright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([ankleright(1) kneeright(1)], [ankleright(3) kneeright(3)], [ankleright(2) kneeright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([ankleright(1) footright(1)], [ankleright(3) footright(3)], [ankleright(2) footright(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([hipleft(1) kneeleft(1)], [hipleft(3) kneeleft(3)], [hipleft(2) kneeleft(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([ankleleft(1) kneeleft(1)], [ankleleft(3) kneeleft(3)], [ankleleft(2) kneeleft(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot3([ankleleft(1) footleft(1)], [ankleleft(3) footleft(3)], [ankleleft(2) footleft(2)], 'color', color,'LineWidth', m);
    hold on;
%     
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
    
    axis equal;
    drawnow;
    set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
    pause(0.01)
    box on;
end

function sketch(xyz, fig, m, l)
    color1 = [0, 0.4470, 0.7410];
    color2 = [0.8500, 0.3250, 0.0980];
    color3 = [0.9290, 0.6940, 0.1250];
    color4 = [0.4940, 0.1840, 0.5560];
    color5 = [0.4660, 0.6740, 0.1880];
    color6 = [0.3010, 0.7450, 0.9330];
    color7 = [0.6350, 0.0780, 0.1840];
    figure(fig);
    clf;
%     xyz = reshape(xyz, 3, 25);
    xyz = trans_pose(xyz);
    spinebase = xyz(:,1);
    plot3(xyz(1,1), xyz(3,1), xyz(2,1), '.', 'Color', color3, 'markersize', l);
    hold on;
    
    spinemid = xyz(:,2);
    plot3(xyz(1,2), xyz(3,2), xyz(2,2), '.', 'Color', color3, 'markersize', l);
    hold on;

    neck = xyz(:,3);
    plot3(xyz(1,3), xyz(3,3), xyz(2,3), '.', 'Color', color3, 'markersize', l);
    hold on;

    head = xyz(:,4);
    plot3(xyz(1,4), xyz(3,4), xyz(2,4), '.', 'Color', color3, 'markersize', l);
    hold on;

    shoulderleft = xyz(:,5);
    plot3(xyz(1,5), xyz(3,5), xyz(2,5), '.', 'Color', color1, 'markersize', l);
    hold on;

    elbowleft = xyz(:,6);
    plot3(xyz(1,6), xyz(3,6), xyz(2,6), '.', 'Color', color1, 'markersize', l);
    hold on;

    wristleft = xyz(:,7);
    plot3(xyz(1,7), xyz(3,7), xyz(2,7), '.', 'Color', color1, 'markersize', l);
    hold on;

    handtipleft = xyz(:,8);
    plot3(xyz(1,8), xyz(3,8), xyz(2,8), '.', 'Color', color1, 'markersize', l);
    hold on;

    shoulderright = xyz(:,9);
    plot3(xyz(1,9), xyz(3,9), xyz(2,9), '.', 'Color', color2, 'markersize', l);
    hold on;

    elbowright = xyz(:,10);
    plot3(xyz(1,10), xyz(3,10), xyz(2,10), '.', 'Color', color2, 'markersize', l);
    hold on;

    wristright = xyz(:,11);
    plot3(xyz(1,11), xyz(3,11), xyz(2,11), '.', 'Color', color2, 'markersize', l);
    hold on;

    handtipright = xyz(:,12);
    plot3(xyz(1,12), xyz(3,12), xyz(2,12), '.', 'Color', color2, 'markersize', l);
    hold on;

    hipleft = xyz(:,13);
    plot3(xyz(1,13), xyz(3,13), xyz(2,13), '.', 'Color', color1, 'markersize', l);
    hold on;

    kneeleft = xyz(:,14);
    plot3(xyz(1,14), xyz(3,14), xyz(2,14), '.', 'Color', color1, 'markersize', l);
    hold on;

    ankleleft = xyz(:,15);
    plot3(xyz(1,15), xyz(3,15), xyz(2,15), '.', 'Color', color1, 'markersize', l);
    hold on;

    footleft = xyz(:,16);
    plot3(xyz(1,16), xyz(3,16), xyz(2,16), '.', 'Color', color1, 'markersize', l);
    hold on;

    hipright = xyz(:,17);
    plot3(xyz(1,17), xyz(3,17), xyz(2,17), '.', 'Color', color2, 'markersize', l);
    hold on;

    kneeright = xyz(:,18);
    plot3(xyz(1,18), xyz(3,18), xyz(2,18), '.', 'Color', color2, 'markersize', l);
    hold on;

    ankleright = xyz(:,19);
    plot3(xyz(1,19), xyz(3,19), xyz(2,19), '.', 'Color', color2, 'markersize', l);
    hold on;

    footright = xyz(:,20);
    plot3(xyz(1,20), xyz(3,20), xyz(2,20), '.', 'Color', color2, 'markersize', l);
    hold on;

    spineshoulder = xyz(:,21);
    plot3(xyz(1,21), xyz(3,21), xyz(2,21), '.', 'Color', color3, 'markersize', l);
    hold on;

    handtipleft = xyz(:,22);
    plot3(xyz(1,22), xyz(3,22), xyz(2,22), '.', 'Color', color1, 'markersize', l);
    hold on;

    thumbleft = xyz(:,23);
    plot3(xyz(1,23), xyz(3,23), xyz(2,23), '.', 'Color', color1, 'markersize', l);
    hold on;

    handtipright = xyz(:,24);
    plot3(xyz(1,24), xyz(3,24), xyz(2,24), '.', 'Color', color1, 'markersize', l);
    hold on;

    thumbright = xyz(:,25);
    plot3(xyz(1,25), xyz(3,25), xyz(2,25), '.', 'Color', color2, 'markersize', l);
    hold on;
    
    plot3([head(1) neck(1)], [head(3) neck(3)], [head(2) neck(2)], 'color', color3, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) neck(1)], [spineshoulder(3) neck(3)], [spineshoulder(2) neck(2)], 'color', color3, 'LineWidth', m);
    hold on;
    plot3([spinebase(1) hipright(1)], [spinebase(3) hipright(3)], [spinebase(2) hipright(2)], 'color', color7, 'LineWidth', m);
    hold on;
    plot3([spinebase(1) hipleft(1)], [spinebase(3) hipleft(3)], [spinebase(2) hipleft(2)], 'color', color6, 'LineWidth', m);
    hold on;
    plot3([spinebase(1) spinemid(1)], [spinebase(3) spinemid(3)], [spinebase(2) spinemid(2)], 'color', color3, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) spinemid(1)], [spineshoulder(3) spinemid(3)], [spineshoulder(2) spinemid(2)], 'color', color3, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) shoulderright(1)], [spineshoulder(3) shoulderright(3)], [spineshoulder(2) shoulderright(2)], 'color', color5, 'LineWidth', m);
    hold on;
    plot3([shoulderright(1) elbowright(1)], [shoulderright(3) elbowright(3)], [shoulderright(2) elbowright(2)], 'color', color2, 'LineWidth', m);
    hold on;
    plot3([wristright(1) elbowright(1)], [wristright(3) elbowright(3)], [wristright(2) elbowright(2)], 'color', color2, 'LineWidth', m);
    hold on;
    plot3([wristright(1) handtipright(1)], [wristright(3) handtipright(3)], [wristright(2) handtipright(2)], 'color', color2, 'LineWidth', m);
    hold on;
    plot3([spineshoulder(1) shoulderleft(1)], [spineshoulder(3) shoulderleft(3)], [spineshoulder(2) shoulderleft(2)], 'color', color4, 'LineWidth', m);
    hold on;
    plot3([shoulderleft(1) elbowleft(1)], [shoulderleft(3) elbowleft(3)], [shoulderleft(2) elbowleft(2)], 'color', color1, 'LineWidth', m);
    hold on;
    plot3([wristleft(1) elbowleft(1)], [wristleft(3) elbowleft(3)], [wristleft(2) elbowleft(2)], 'color', color1, 'LineWidth', m);
    hold on;
    plot3([wristleft(1) handtipleft(1)], [wristleft(3) handtipleft(3)], [wristleft(2) handtipleft(2)], 'color', color1, 'LineWidth', m);
    hold on;
    plot3([hipright(1) kneeright(1)], [hipright(3) kneeright(3)], [hipright(2) kneeright(2)], 'color', color2, 'LineWidth', m);
    hold on;
    plot3([ankleright(1) kneeright(1)], [ankleright(3) kneeright(3)], [ankleright(2) kneeright(2)], 'color', color2, 'LineWidth', m);
    hold on;
    plot3([ankleright(1) footright(1)], [ankleright(3) footright(3)], [ankleright(2) footright(2)], 'color', color2, 'LineWidth', m);
    hold on;
    plot3([hipleft(1) kneeleft(1)], [hipleft(3) kneeleft(3)], [hipleft(2) kneeleft(2)], 'color', color1, 'LineWidth', m);
    hold on;
    plot3([ankleleft(1) kneeleft(1)], [ankleleft(3) kneeleft(3)], [ankleleft(2) kneeleft(2)], 'color', color1, 'LineWidth', m);
    hold on;
    plot3([ankleleft(1) footleft(1)], [ankleleft(3) footleft(3)], [ankleleft(2) footleft(2)], 'color', color1,'LineWidth', m);
    hold on;
%     
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
    
    axis equal;
    drawnow;
    set(gca,'XTick',[], 'YTick', [], 'ZTick', []);
    pause(0.01)
    box on;
end

function opose(xyz, fig, color, m)
    figure(fig);
    xyz = reshape(xyz, 2, 25);
    xyz(2,:) = -xyz(2,:);
    
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
%     headcloud = xyz(:, [16, 17, 18, 19]);
    
    clf;
    
    plot([head(1) center(1)], [head(2) center(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([bottom(1) center(1)], [bottom(2) center(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([rightshoulder(1) center(1)], [rightshoulder(2) center(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([leftshoulder(1) center(1)], [leftshoulder(2) center(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([leftshoulder(1) leftelbow(1)], [leftshoulder(2) leftelbow(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([lefthand(1) leftelbow(1)], [lefthand(2) leftelbow(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([rightshoulder(1) rightelbow(1)], [rightshoulder(2) rightelbow(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([righthand(1) rightelbow(1)], [righthand(2) rightelbow(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([bottom(1) lefthip(1)], [bottom(2) lefthip(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([bottom(1) righthip(1)], [bottom(2) righthip(2)], 'color', color, 'LineWidth', m);
    hold on;
    plot([leftknee(1) lefthip(1)], [leftknee(2) lefthip(2)], 'color', color, 'LineWidth', m);
    hold on;
%     plot([leftknee(1) leftfoot(1)], [leftknee(2) leftfoot(2)], 'color', color, 'LineWidth', m);
%     hold on;
    plot([rightknee(1) righthip(1)], [rightknee(2) righthip(2)], 'color', color, 'LineWidth', m);
    hold on;
%     plot([rightknee(1) rightfoot(1)], [rightknee(2) rightfoot(2)], 'color', color, 'LineWidth', m);
%     hold on;
    plot(xyz(1,:), xyz(2,:), '.', 'Color', color', 'markersize', 25);
    
    axis equal;
    drawnow;

    
    pause(0.01)
end
