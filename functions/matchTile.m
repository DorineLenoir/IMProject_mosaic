function bestTileIndex = matchTile(blockFeature, tileFeatures)
%Finds the tile whose feature is closest to the block feature.
    distances = sqrt(sum((tileFeatures-blockFeature).^2,2));
    [~, bestTileIndex]=min(distances);
end