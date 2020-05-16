function d = euc_dist(gt, test)
    d = sqrt((gt(1)-test(1))^2 + (gt(2)-test(2))^2 + (gt(3)-test(3))^2);
end