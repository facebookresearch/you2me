seq_len = 1025;
frame_sum = zeros(seq_len + 1, 1);
total_joint = zeros(25, 1);
nan_count = 0;
for n = 1:seq_len
    pose_sum = 0;
    test_xyz = load(sprintf('../output/r%d.txt', n));
%     test_xyz = load(sprintf('../vid2pose/always_stand/r%d.txt', n));
    test_xyz = trans_pose(test_xyz); % transforms pose to specific alignments
    
    gt_xyz = load(sprintf('../sample_dir/convo2/p%d.txt', n));
    gt_xyz = trans_pose(gt_xyz);
    
    % calculate the difference in distances between each of the same points 
    for i = 1:length(gt_xyz)
        dist = abs(euc_dist(gt_xyz(:, i), test_xyz(:, i)));
        total_joint(i) = total_joint(i) + dist;
        pose_sum = pose_sum + dist; 
    end
    if isnan(pose_sum)
        nan_count = nan_count + 1;
    else
        frame_sum(n+1, 1) = pose_sum;
    end
end
res = sum(frame_sum)/(seq_len - nan_count);
% convert raw errors to 30 cm shoulders
xyz = load(sprintf('../output/r%d.txt', n));
xyz = reshape(xyz, 3, 25);
d = euc_dist(xyz(:, 9), xyz(:, 5));
% res = res / 5 * d / 25;
r = 30/d; % calculate scaling ratio
res = res * r / 25;
fprintf('total: %f\n', res);
upper = sum(total_joint([2 3 4 5 6 7 8 9 10 11 12 21 22 23 24 25]));
upper = upper * r / 15 / seq_len;
fprintf('upper: %f\n', upper);
lower = sum(total_joint([1 13 14 15 16 17 18 19 20]));
lower = lower * r / 9 / seq_len;
fprintf('lower: %f\n', lower);

total_joint = total_joint * r / seq_len;

% frame_sum(1, 1) = res; % store the average error at the top of the file
% fileID = fopen('results/stats.txt', 'w');
% fprintf(fileID, '%f\n', frame_sum);