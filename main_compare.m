%% main_compare.m — Comparaison de toutes les méthodes de matching
% Image Mosaic Project — VUB Image Processing 2026
%
% Ce script charge la cible et les tuiles UNE SEULE FOIS, puis génère la
% mosaïque avec chaque méthode et compare les résultats (visuel + PSNR + temps).

clc;
clear;
close all;

addpath('functions');

%% Parameters

tileSize    = [15 15];
nBins       = 8;             % pour les méthodes histogramme
weights     = [1 1 1];       % pour la méthode 'combined' [color luminance texture]
saveResults = true;          % met à false si tu ne veux pas écrire sur disque

% Liste des méthodes à comparer (l'ordre = ordre d'affichage)
methods = { ...
    'mean_rgb',                  'Mean RGB (baseline)'; ...
    'luminance',                 'Luminance + std Y'; ...
    'texture',                   'Texture (Sobel)'; ...
    'histogram_l2',              'Histogram L2'; ...
    'histogram_chi2',            'Histogram \chi^2'; ...
    'histogram_intersection',    'Histogram Intersection'; ...
    'histogram_bhattacharyya',   'Histogram Bhattacharyya'; ...
    'combined',                  'Combined (color+lum+tex)'; ...
};

nMethods = size(methods, 1);

%% Step 1 — Load the target image (UNE seule fois)

targetImage = loadTargetImage();

%% Step 2 — Load the tile dataset (UNE seule fois)

tilesFolder = uigetdir(pwd, 'Select the folder containing the tile dataset');
if isequal(tilesFolder, 0)
    error('No tile folder selected.');
end
rawTiles = loadTileDataset(tilesFolder);

%% Step 3 — Resize the tiles (UNE seule fois)

tiles = resizeTiles(rawTiles, tileSize);

%% Step 4 — Crop target to a size that is multiple of tileSize
% Pour que les PSNR soient calculés sur des images EXACTEMENT de même taille
% que les mosaïques retournées.

[H, W, ~] = size(targetImage);
H = tileSize(1) * floor(H / tileSize(1));
W = tileSize(2) * floor(W / tileSize(2));
targetCropped = targetImage(1:H, 1:W, :);

fprintf('\n=== Configuration ===\n');
fprintf('Target size after crop : %d x %d\n', H, W);
fprintf('Tile size              : %d x %d\n', tileSize(1), tileSize(2));
fprintf('Number of tiles        : %d\n', numel(tiles));
fprintf('Methods to test        : %d\n\n', nMethods);

%% Step 5 — Run every method and collect results

mosaics  = cell(nMethods, 1);
timings  = zeros(nMethods, 1);
psnrVals = zeros(nMethods, 1);
ssimVals = zeros(nMethods, 1);

% Options communes aux méthodes (la GUI manipulerait ces champs)
opts = struct( ...
    'nBins',        nBins, ...
    'weights',      weights, ...
    'colorCorrect', true, ...
    'blendAlpha',   0.15);

for k = 1:nMethods
    methodKey  = methods{k, 1};
    methodName = methods{k, 2};

    fprintf('[%d/%d] Running method : %-30s ... ', k, nMethods, methodName);

    tic;
    mosaics{k} = generateMosaic(targetImage, tiles, tileSize, methodKey, opts);
    timings(k) = toc;

    % Métriques de fidélité : PSNR + SSIM (les deux sont dans la
    % Image Processing Toolbox de base et sont des standards du cours).
    psnrVals(k) = psnr(mosaics{k}, targetCropped);
    ssimVals(k) = ssim(mosaics{k}, targetCropped);

    fprintf('done in %6.2f s  |  PSNR = %5.2f dB  |  SSIM = %.3f\n', ...
        timings(k), psnrVals(k), ssimVals(k));
end

%% Step 6 — Display all results in one figure

figure('Name', 'Mosaic Comparison', 'Color', 'w', ...
       'Position', [80 80 1500 800]);

% Layout : grille 3x3, la cible en (1,1), les 8 méthodes ensuite
nCols = 3;
nRows = ceil((nMethods + 1) / nCols);

subplot(nRows, nCols, 1);
imshow(targetCropped);
title('Target image', 'FontWeight', 'bold');

for k = 1:nMethods
    subplot(nRows, nCols, k + 1);
    imshow(mosaics{k});
    title(sprintf('%s\nPSNR = %.2f dB | SSIM = %.3f | %.2fs', ...
        methods{k, 2}, psnrVals(k), ssimVals(k), timings(k)), ...
        'FontSize', 9, 'Interpreter', 'tex');
end

sgtitle(sprintf('Mosaic matching comparison — tile %dx%d, %d tiles', ...
    tileSize(1), tileSize(2), numel(tiles)), 'FontWeight', 'bold');

%% Step 7 — Bar chart : PSNR + temps de calcul

figure('Name', 'Quantitative comparison', 'Color', 'w', ...
       'Position', [120 120 1100 450]);

subplot(1, 2, 1);
bar(psnrVals);
set(gca, 'XTickLabel', methods(:,2), 'XTickLabelRotation', 30, 'FontSize', 9);
ylabel('PSNR (dB)');
title('Reconstruction quality (higher is better)');
grid on;

subplot(1, 2, 2);
bar(timings);
set(gca, 'XTickLabel', methods(:,2), 'XTickLabelRotation', 30, 'FontSize', 9);
ylabel('Time (s)');
title('Computation time (lower is better)');
grid on;

%% Step 8 — Recap text in the console

fprintf('\n=== Summary ===\n');
fprintf('%-35s | %8s | %6s | %6s\n', 'Method', 'Time (s)', 'PSNR', 'SSIM');
fprintf('%s\n', repmat('-', 1, 70));
for k = 1:nMethods
    fprintf('%-35s | %8.2f | %6.2f | %6.3f\n', ...
        methods{k, 2}, timings(k), psnrVals(k), ssimVals(k));
end

[~, bestPSNR] = max(psnrVals);
[~, bestSSIM] = max(ssimVals);
[~, fastest]  = min(timings);
fprintf('\n>> Best PSNR  : %s (%.2f dB)\n', methods{bestPSNR, 2}, psnrVals(bestPSNR));
fprintf('>> Best SSIM  : %s (%.3f)\n',    methods{bestSSIM, 2}, ssimVals(bestSSIM));
fprintf('>> Fastest    : %s (%.2f s)\n',  methods{fastest, 2},  timings(fastest));

%% Step 9 — Save results

if saveResults
    if ~exist('results', 'dir')
        mkdir('results');
    end

    % Sauvegarde de chaque mosaïque
    for k = 1:nMethods
        fname = sprintf('mosaic_%s.png', methods{k, 1});
        imwrite(mosaics{k}, fullfile('results', fname));
    end

    % Sauvegarde de la figure récapitulative
    saveas(figure(1), fullfile('results', 'comparison_grid.png'));
    saveas(figure(2), fullfile('results', 'comparison_metrics.png'));

    % Sauvegarde du tableau de métriques en CSV (pour le rapport LaTeX)
    T = table( methods(:,1), methods(:,2), timings, psnrVals, ssimVals, ...
        'VariableNames', {'MethodKey', 'MethodName', 'Time_s', 'PSNR_dB', 'SSIM'});
    writetable(T, fullfile('results', 'metrics.csv'));

    fprintf('\nAll results saved in ./results/\n');
end