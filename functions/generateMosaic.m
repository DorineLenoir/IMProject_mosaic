function mosaic = generateMosaic(target, tiles, tileSize, method, opts)
%Build the photomosaic by replacing each block by its best tile.


    if nargin < 4 || isempty(method), method = 'mean_rgb'; end
    if nargin < 5,                    opts   = struct();   end
    if ~isfield(opts, 'nBins'),        opts.nBins = 8;        end
    if ~isfield(opts, 'weights'),      opts.weights = [1 1 1]; end
    if ~isfield(opts, 'colorCorrect'), opts.colorCorrect = false; end
    if ~isfield(opts, 'blendAlpha'),   opts.blendAlpha = 0;       end

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

        % case {'histogram_l2', 'histogram_chi2', 'histogram_intersection', 'histogram_bhattacharyya'}
        %     tileFeatures = computeTileFeatures_histogram(tiles, opts.nBins);
        %     featFun      = @(blk) computeBlockFeature_histogram(blk, opts.nBins);
        %     switch lower(method)
        %         case 'histogram_l2',            metric = 'l2';
        %         case 'histogram_chi2',          metric = 'chi2';
        %         case 'histogram_intersection',  metric = 'intersection';
        %         case 'histogram_bhattacharyya', metric = 'bhattacharyya';
        %     end
        case {'histogram_bhattacharyya'}
            tileFeatures = computeTileFeatures_histogram(tiles, opts.nBins);
            featFun      = @(blk) computeBlockFeature_histogram(blk, opts.nBins);
            matchFun = @(bf) matchTile_histogram(bf, tileFeatures, 'bhattacharyya');

        case 'combined'
            tileFeatures = computeTileFeatures_combined(tiles, opts.weights);
            featFun      = @(blk) computeBlockFeature_combined(blk, opts.weights);
            matchFun     = @(bf)  matchTile(bf, tileFeatures);

        otherwise
            error('generateMosaic:unknownMethod', ...
                'Unknown matching method "%s".', method);
    end

  
    [H, W, ~] = size(target);
    tileH = tileSize(1); tileW = tileSize(2);

    H = tileH * floor(H / tileH);
    W = tileW * floor(W / tileW);
    target = target(1:H, 1:W, :);
    mosaic = zeros(H, W, 3);

    for r = 1:tileH:H
        for c = 1:tileW:W
            block = target(r:r+tileH-1, c:c+tileW-1, :);

            bf       = featFun(block);
            bestIdx  = matchFun(bf);
            bestTile = tiles{bestIdx};

            if opts.colorCorrect
                bestTile = applyColorCorrection(bestTile, block);
            end

            if opts.blendAlpha > 0
                bestTile = applyBlending(bestTile, block, opts.blendAlpha);
            end

            mosaic(r:r+tileH-1, c:c+tileW-1, :) = bestTile;
        end
    end
end