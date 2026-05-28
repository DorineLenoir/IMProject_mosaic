function tiles = resizeTiles(rawTiles, tileSize)
%RESIZETILES Resizes all tile images to the same size.

    numTiles = length(rawTiles);
    tiles = cell(numTiles, 1);

    for i = 1:numTiles
        tiles{i} = imresize(rawTiles{i}, tileSize);
    end

    fprintf('All tiles resized to %d x %d pixels.\n', tileSize(1), tileSize(2));

end