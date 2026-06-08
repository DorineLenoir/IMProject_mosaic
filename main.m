
clc;
clear;
close all;

addpath('functions');


tileSize=[30 30];
nBins= 8;
weights = [3 1 1];
saveResults = false;

useTriangleTiles = false;

opts = struct( ...
    'nBins',        nBins, ...
    'weights',      weights, ...
    'colorCorrect', true, ...
    'blendAlpha',   0.15);



if useTriangleTiles

    methods = { ...
        'triangle_mean_rgb', 'Triangular Mosaic - Mean RGB'; ...
    };

else

    methods={ ...
        'mean_rgb',                'Mean RGB (baseline)'; ...
        'luminance',               'Luminance + std Y'; ...
        'texture',                 'Texture (Sobel)'; ...
        'histogram_bhattacharyya', 'Histogram Bhattacharyya'; ...
        'combined',                'Combined (color+lum+tex)'; ...
    };

end

nMethods= size(methods, 1);
targetImage = loadTargetImage();
tilesFolder = uigetdir(pwd, 'Select the folder containing the tile dataset');

if isequal(tilesFolder, 0)
    error('No tile folder selected.');
end

rawTiles = loadTileDataset(tilesFolder);
tiles = resizeTiles(rawTiles, tileSize);

[H, W, ~] = size(targetImage);

H = tileSize(1) * floor(H / tileSize(1));
W = tileSize(2) * floor(W / tileSize(2));

targetCropped = targetImage(1:H, 1:W, :);

if useTriangleTiles
    shapeName = 'Triangular';
else
    shapeName = 'Square';
end

fprintf('\n=== Configuration ===\n');
fprintf('Target size after crop : %d x %d\n', H, W);
fprintf('Tile size              : %d x %d\n', tileSize(1), tileSize(2));
fprintf('Number of tiles        : %d\n', numel(tiles));
fprintf('Tile shape             : %s\n', shapeName);
fprintf('Methods to test        : %d\n\n', nMethods);



mosaics  = cell(nMethods, 1);
timings  = zeros(nMethods, 1);
psnrVals = zeros(nMethods, 1);
ssimVals = zeros(nMethods, 1);

for k = 1:nMethods

    methodKey  = methods{k, 1};
    methodName = methods{k, 2};

    fprintf('[%d/%d] Running method: %-30s ... ', ...
        k, nMethods, methodName);

    tic;

    if useTriangleTiles

        mosaics{k} = generateTriangleMosaic( ...
            targetImage, tiles, tileSize, opts);

    else

        mosaics{k} = generateMosaic( ...
            targetImage, tiles, tileSize, methodKey, opts);

    end

    timings(k) = toc;

    psnrVals(k) = psnr(mosaics{k}, targetCropped);
    ssimVals(k) = ssim(mosaics{k}, targetCropped);

    fprintf('done in %6.2f s | PSNR = %5.2f dB | SSIM = %.3f\n', ...
        timings(k), psnrVals(k), ssimVals(k));

end



figure('Name', 'Mosaic Results', 'Color', 'w', ...
       'Position', [50 50 1800 1000]);

nCols = 3;
nRows = ceil((nMethods + 1) / nCols);

layout = tiledlayout(nRows, nCols, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact');

nexttile;
imshow(targetCropped);
title('Target image', 'FontWeight', 'bold', 'FontSize', 12);

for k = 1:nMethods

    nexttile;
    imshow(mosaics{k});

    title(sprintf('%s\nPSNR = %.2f dB | SSIM = %.3f | %.2fs', ...
        methods{k, 2}, psnrVals(k), ssimVals(k), timings(k)), ...
        'FontSize', 10, ...
        'Interpreter', 'tex');

end

title(layout, sprintf('%s mosaic comparison — tile %dx%d, %d tiles', ...
    shapeName, tileSize(1), tileSize(2), numel(tiles)), ...
    'FontWeight', 'bold', ...
    'FontSize', 16);



figure('Name', 'Quantitative Comparison', 'Color', 'w', ...
       'Position', [120 120 1100 450]);

subplot(1, 2, 1);
bar(psnrVals);
set(gca, ...
    'XTickLabel', methods(:, 2), ...
    'XTickLabelRotation', 30, ...
    'FontSize', 9);
ylabel('PSNR (dB)');
title('Reconstruction quality');
grid on;

subplot(1, 2, 2);
bar(timings);
set(gca, ...
    'XTickLabel', methods(:, 2), ...
    'XTickLabelRotation', 30, ...
    'FontSize', 9);
ylabel('Time (s)');
title('Computation time');
grid on;



figure('Name', 'SSIM Comparison', 'Color', 'w', ...
       'Position', [150 150 700 450]);

bar(ssimVals);
set(gca, ...
    'XTickLabel', methods(:, 2), ...
    'XTickLabelRotation', 30, ...
    'FontSize', 9);
ylabel('SSIM');
title('Structural similarity');
grid on;

fprintf('\n=== Summary ===\n');
fprintf('%-35s | %8s | %6s | %6s\n', ...
    'Method', 'Time (s)', 'PSNR', 'SSIM');
fprintf('%s\n', repmat('-', 1, 70));

for k = 1:nMethods

    fprintf('%-35s | %8.2f | %6.2f | %6.3f\n', ...
        methods{k, 2}, timings(k), psnrVals(k), ssimVals(k));

end

[~, bestPSNR] = max(psnrVals);
[~, bestSSIM] = max(ssimVals);
[~, fastest]  = min(timings);

fprintf('\nBest PSNR : %s (%.2f dB)\n', ...
    methods{bestPSNR, 2}, psnrVals(bestPSNR));

fprintf('Best SSIM : %s (%.3f)\n', ...
    methods{bestSSIM, 2}, ssimVals(bestSSIM));

fprintf('Fastest   : %s (%.2f s)\n', ...
    methods{fastest, 2}, timings(fastest));


if saveResults

    if ~exist('results', 'dir')
        mkdir('results');
    end

    for k = 1:nMethods

        if useTriangleTiles
            imageName = sprintf('mosaic_triangle_%s.png', methods{k, 1});
        else
            imageName = sprintf('mosaic_square_%s.png', methods{k, 1});
        end

        imwrite(mosaics{k}, fullfile('results', imageName));

    end

    metricsTable = table( ...
        methods(:, 1), ...
        methods(:, 2), ...
        timings, ...
        psnrVals, ...
        ssimVals, ...
        'VariableNames', {'MethodKey', 'MethodName', 'Time_s', 'PSNR_dB', 'SSIM'});

    if useTriangleTiles
        writetable(metricsTable, fullfile('results', 'metrics_triangle.csv'));
    else
        writetable(metricsTable, fullfile('results', 'metrics_square.csv'));
    end

    exportgraphics(figure(1), fullfile('results', 'mosaic_comparison.png'), ...
        'Resolution', 300);

    exportgraphics(figure(2), fullfile('results', 'psnr_time_comparison.png'), ...
        'Resolution', 300);

    exportgraphics(figure(3), fullfile('results', 'ssim_comparison.png'), ...
        'Resolution', 300);

    fprintf('\nAll results saved in ./results/\n');

end