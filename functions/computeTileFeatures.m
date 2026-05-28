function tileFeatures = computeTileFeatures(tiles)
%COMPUTETILEFEATURES Computes the average RGB color of each tile.
% Each tile is represented by a vector [mean_R, mean_G, mean_B].

    numTiles = length(tiles);
    tileFeatures = zeros(numTiles, 3);

    for i = 1:numTiles

        tile = tiles{i};

        meanR = mean(tile(:, :, 1), 'all');
        meanG = mean(tile(:, :, 2), 'all');
        meanB = mean(tile(:, :, 3), 'all');

        tileFeatures(i, :) = [meanR, meanG, meanB];

    end

    disp('Tile features computed.');

end