function bestTileIndex = matchTile(blockFeature, tileFeatures)
%MATCHTILE Finds the tile whose feature is closest to the block feature.
% The comparison is based on the Euclidean distance in RGB space.

    distances = sqrt(sum((tileFeatures - blockFeature).^2, 2));

    [~, bestTileIndex] = min(distances);

end