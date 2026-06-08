function blockFeature = computeBlockFeature(block)
%Computes the average RGB color of one target block.

    meanR = mean(block(:, :, 1), 'all');
    meanG = mean(block(:, :, 2), 'all');
    meanB = mean(block(:, :, 3), 'all');

    blockFeature = [meanR, meanG, meanB];
end