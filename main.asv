

r;
close all;

addpath('functions');

%% Parameters

tileSize = [15 15];

%% Step 1 — Load the target image

targetImage = loadTargetImage();

%% Step 2 — Load the tile dataset

tilesFolder = uigetdir(pwd, 'Select the folder containing the tile dataset');

if tilesFolder == 0
    error('No tile folder selected.');
end

rawTiles = loadTileDataset(tilesFolder);

%% Step 3 — Resize the tiles

tiles = resizeTiles(rawTiles, tileSize);

%% Step 5 — Compute the features of the tiles

tileFeatures = computeTileFeatures(tiles);

%% Step 4, 6 and 7 — Generate the mosaic

mosaicImage = generateMosaic(targetImage, tiles, tileFeatures, tileSize);

%% Display results

figure;
subplot(1, 2, 1);
imshow(targetImage);I
title('Target Image');

subplot(1, 2, 2);
imshow(mosaicImage);
title('Generated Mosaic');

%% Save result

if ~exist('results', 'dir')
    mkdir('results');
end

%imwrite(mosaicImage, fullfile('results', 'mosaic_result.png'));

%disp('Mosaic saved in results/mosaic_result.png');