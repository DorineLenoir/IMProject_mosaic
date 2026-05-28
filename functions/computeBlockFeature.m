function blockFeature = computeBlockFeature(block)
%COMPUTEBLOCKFEATURE Computes the average RGB color of one target block.
% The block is represented by a vector [mean_R, mean_G, mean_B].

    meanR = mean(block(:, :, 1), 'all');
    meanG = mean(block(:, :, 2), 'all');
    meanB = mean(block(:, :, 3), 'all');

    blockFeature = [meanR, meanG, meanB];

end