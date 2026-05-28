function mosaic = generateMosaic(target, tiles, tileSize, method, opts)
%GENERATEMOSAIC Build the photomosaic by replacing each block by its best tile.
%
%   mosaic = generateMosaic(target, tiles, tileSize, method, opts)
%
%   Inputs:
%     target   : HxWx3 double image in [0,1] (output of loadTargetImage)
%     tiles    : 1xN cell array of tileSize(1) x tileSize(2) x 3 double tiles
%                (already resized via resizeTiles)
%     tileSize : 1x2 vector [tileH tileW]
%     method   : matching strategy, one of:
%                  'mean_rgb'                 (baseline, partner's code)
%                  'luminance'
%                  'texture'
%                  'histogram_l2'
%                  'histogram_chi2'
%                  'histogram_intersection'
%                  'histogram_bhattacharyya'
%                  'combined'
%     opts     : (optional) struct with method-specific parameters:
%                  opts.nBins         (histogram methods, default 8)
%                  opts.weights       (combined, default [1 1 1])
%                  opts.colorCorrect  (logical, default false) -- apply
%                                     applyColorCorrection per block
%                  opts.blendAlpha    (scalar in [0,1], default 0) -- alpha
%                                     blending strength with the original block
%
%   Output:
%     mosaic   : HxWx3 double image in [0,1]
%
%   This function contains NO UI calls and NO global state — it is meant
%   to be invoked from main.m or from the GUI built on top.
%
%   See also: computeTileFeatures, computeBlockFeature, matchTile,
%             computeTileFeatures_luminance, computeTileFeatures_texture,
%             computeTileFeatures_histogram, computeTileFeatures_combined,
%             applyColorCorrection, applyBlending

    if nargin < 4 || isempty(method), method = 'mean_rgb'; end
    if nargin < 5,                    opts   = struct();   end
    if ~isfield(opts, 'nBins'),        opts.nBins = 8;        end
    if ~isfield(opts, 'weights'),      opts.weights = [1 1 1]; end
    if ~isfield(opts, 'colorCorrect'), opts.colorCorrect = false; end
    if ~isfield(opts, 'blendAlpha'),   opts.blendAlpha = 0;       end

    % --- 1. Precompute tile features ONCE (huge speed gain) -------------
    switch lower(method)
        case 'mean_rgb'
            tileFeatures = computeTileFeatures(tiles);
            featFun      = @(blk) computeBlockFeature(blk);
            matchFun     = @(bf)  matchTile(bf, tileFeatures);

        case 'luminance'
            tileFeatures = computeTileFeatures_luminance(tiles);
            featFun      = @(blk) computeBlockFeature_luminance(blk);
            matchFun     = @(bf)  matchTile(bf, tileFeatures);

        case 'texture'
            tileFeatures = computeTileFeatures_texture(tiles);
            featFun      = @(blk) computeBlockFeature_texture(blk);
            matchFun     = @(bf)  matchTile(bf, tileFeatures);

        case {'histogram_l2', 'histogram_chi2', ...
              'histogram_intersection', 'histogram_bhattacharyya'}
            tileFeatures = computeTileFeatures_histogram(tiles, opts.nBins);
            featFun      = @(blk) computeBlockFeature_histogram(blk, opts.nBins);
            switch lower(method)
                case 'histogram_l2',            metric = 'l2';
                case 'histogram_chi2',          metric = 'chi2';
                case 'histogram_intersection',  metric = 'intersection';
                case 'histogram_bhattacharyya', metric = 'bhattacharyya';
            end
            matchFun = @(bf) matchTile_histogram(bf, tileFeatures, metric);

        case 'combined'
            tileFeatures = computeTileFeatures_combined(tiles, opts.weights);
            featFun      = @(blk) computeBlockFeature_combined(blk, opts.weights);
            matchFun     = @(bf)  matchTile(bf, tileFeatures);

        otherwise
            error('generateMosaic:unknownMethod', ...
                'Unknown matching method "%s".', method);
    end

    % --- 2. Loop over blocks --------------------------------------------
    [H, W, ~] = size(target);
    tileH = tileSize(1); tileW = tileSize(2);

    % Crop the target so its size is an exact multiple of the tile size
    H = tileH * floor(H / tileH);
    W = tileW * floor(W / tileW);
    target = target(1:H, 1:W, :);
    mosaic = zeros(H, W, 3);

    for r = 1:tileH:H
        for c = 1:tileW:W
            block = target(r:r+tileH-1, c:c+tileW-1, :);

            % Feature extraction + matching (modular dispatch above)
            bf       = featFun(block);
            bestIdx  = matchFun(bf);
            bestTile = tiles{bestIdx};

            % Optional color correction (Finkelstein & Range, Sec 4.4)
            if opts.colorCorrect
                bestTile = applyColorCorrection(bestTile, block);
            end

            % Optional alpha blending with the original block
            if opts.blendAlpha > 0
                bestTile = applyBlending(bestTile, block, opts.blendAlpha);
            end

            mosaic(r:r+tileH-1, c:c+tileW-1, :) = bestTile;
        end
    end
end