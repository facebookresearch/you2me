function rot_xyz = trans_pose(xyz)
    xyz = reshape(xyz, 3, 25);

    % translate body so shoulder 9 to origin
    to_orig = xyz(:, 9)';
    s9_xyz = zeros(size(xyz));
    for i = 1:length(xyz)
        s9_xyz(:, i) = xyz(:, i)' - to_orig;
    end

    % find angle (alpha) between vec on yz plane and shoulder line
    v = [0, 0, 1]; % vector in yz plane
    u = [s9_xyz(1,5), 0, s9_xyz(3, 5)]; % project s9 onto the x plane
    v = v/norm(v);
    u = u/norm(u);
    alpha = -acos(dot(u, v));

    % rot matrix for rotating around y axis
    R = [cos(alpha),  0,    sin(alpha) ;
         0,           1,    0;
         -sin(alpha), 0,    cos(alpha)];

    rot_xyz = zeros(size(s9_xyz));
    for i = 1:length(s9_xyz)
        t = (R * s9_xyz(:, i))';
        rot_xyz(:, i) = t;
    end

    % translate body so center is to origin
    to_orig = rot_xyz(:, 2)';
    for i = 1:length(xyz)
        rot_xyz(:, i) = rot_xyz(:, i)' - to_orig;
    end
    
    % TODO: check if arm is negative, if yes, redo rot with negative alpha?
    handtipleft = rot_xyz(:, 22);
    handtipright = rot_xyz(:, 24);
    if handtipleft(1) > 0 && handtipright(1) > 0
        alpha = 3.14159;
        R = [cos(alpha),  0,    sin(alpha) ;
            0,           1,    0;
            -sin(alpha), 0,    cos(alpha)];

%         rot_xyz = zeros(size(s9_xyz));
        for i = 1:length(s9_xyz)
            t = (R * rot_xyz(:, i))';
            rot_xyz(:, i) = t;
        end

        % translate body so center is to origin
        to_orig = rot_xyz(:, 2)';
        for i = 1:length(xyz)
            rot_xyz(:, i) = rot_xyz(:, i)' - to_orig;
        end
    end
    
%     alpha = 2.0;
%     R = [cos(alpha),  0,    sin(alpha) ;
%          0,           1,    0;
%          -sin(alpha), 0,    cos(alpha)];
%     xyz = zeros(size(rot_xyz));
%     for i = 1:length(xyz)
%         t = (R * rot_xyz(:, i))';
%         xyz(:, i) = t;
%     end
%     rot_xyz = xyz;

    
    %{
    rot_xyz(:, 5)'
    rot_xyz(:, 9)'
    rot_xyz(:, 2)'
    figure(1);
    plot3(rot_xyz(1,:), rot_xyz(3,:), rot_xyz(2,:), '.', 'markersize', 40);
    xlabel('x', 'Rotation',20)
    ylabel('y', 'Rotation',-30)
    zlabel('z') 
    axis equal;
    drawnow;
    figure(2);
    plot3(xyz(1,:), xyz(3,:), xyz(2,:), '.', 'markersize', 40);
    xlabel('x', 'Rotation',20)
    ylabel('y', 'Rotation',-30)
    zlabel('z') 
    axis equal;
    drawnow;
    %}
end
