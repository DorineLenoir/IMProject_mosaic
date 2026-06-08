function tiles = resizeTiles(rawTiles, tileSize,d)
%Resizes all tile images to the same size.

    numTiles = length(rawTiles);
    tiles = cell(numTiles, 1);

    for i = 1:numTiles
        tiles{i} = imresize(rawTiles{i}, tileSize);

        if nargin > 2 && isvalid(d)
            d.Value = i / numTiles;
            d.Message = sprintf('Resizing tile %d of %d...', i, numTiles);
        end
    end

end