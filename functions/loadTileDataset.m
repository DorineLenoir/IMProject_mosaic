function rawTiles = loadTileDataset(tilesFolder)
%LOADTILEDATASET Loads all tile images from a selected folder.
% The images are not resized here yet.

    imageExtensions = {'*.jpg', '*.jpeg', '*.png', '*.bmp'};

    tileFiles = [];

    for i = 1:length(imageExtensions)
        tileFiles = [tileFiles; dir(fullfile(tilesFolder, imageExtensions{i}))];
    end

    numTiles = length(tileFiles);

    if numTiles == 0
        error('No tile images found in the selected folder.');
    end

    rawTiles = cell(numTiles, 1);

    for i = 1:numTiles

        tilePath = fullfile(tilesFolder, tileFiles(i).name);
        tileImage = imread(tilePath);

        % Convert grayscale image to RGB if needed
        if size(tileImage, 3) == 1
            tileImage = repmat(tileImage, [1 1 3]);
        end

        tileImage = im2double(tileImage);

        rawTiles{i} = tileImage;

    end

    fprintf('Number of tiles loaded: %d\n', numTiles);

end