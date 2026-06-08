clear; clc; close all;


addpath('functions');

targetFolder = 'flowers'; 
tileSize = 30;
matchingMethod = 'luminance';

targetImage = im2double(imread('target.png'));


tiles = loadTileDataset(targetFolder);
tiles = resizeTiles(tiles, tileSize);


fprintf('Calcul de la mosaïque en cours...\n');


finalMosaic = generateMosaic(targetImage, tiles, tileSize, matchingMethod);

figure;
subplot(1,2,1); imshow(targetImage); title('Original');
subplot(1,2,2); imshow(finalMosaic); title('Mosaic Result');