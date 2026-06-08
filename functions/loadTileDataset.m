function rawTiles = loadTileDataset(tilesFolder)
%Loads all tile images from a selected folder.

    matFiles = dir(fullfile(tilesFolder, '*batch*.mat'));

    if ~isempty(matFiles)
        rawTiles={};

        for f =1:length(matFiles)
            batchpath=fullfile(tilesFolder,matFiles(f).name);
            batchdata=load(batchpath);

            if isfield(batchdata,'data')
                X=batchdata.data;
                numImages=size(X,1);
                batchtiles=cell(numImages,1);

                for i = 1:numImages
                    imgRow= X(i, :);
                    
                    R = reshape(imgRow(1:1024), [32, 32]).';
                    G = reshape(imgRow(1025:2048), [32, 32]).';
                    B = reshape(imgRow(2049:3072), [32, 32]).';
                    
                    tileImage = cat(3, R, G, B);
                   
                    batchtiles{i} = im2double(tileImage);
                end
                
               
                rawTiles = [rawTiles; batchtiles];
            end
        end

        numTiles=length(rawTiles);
        if numTiles==0
            error("no valid data matrix in batch files");
        end
    else


    imageExtensions ={'*.jpg', '*.jpeg', '*.png', '*.bmp'};

    tileFiles =[];

    for i= 1:length(imageExtensions)
        tileFiles = [tileFiles; dir(fullfile(tilesFolder, imageExtensions{i}))];
    end

    numTiles = length(tileFiles);

    if numTiles == 0
        error('No tile images found in the selected folder.');
    end

    rawTiles = cell(numTiles, 1);

    for i = 1:numTiles

        tilePath= fullfile(tilesFolder, tileFiles(i).name);
        tileImage = imread(tilePath);

        if size(tileImage,3)== 1
            tileImage = repmat(tileImage, [1 1 3]);
        end
        tileImage = im2double(tileImage);
        rawTiles{i} =tileImage;

    end
    fprintf('Number of tiles loaded: %d\n', numTiles);
    end
end