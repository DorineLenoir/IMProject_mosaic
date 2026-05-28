function targetImage = loadTargetImage()
%LOADTARGETIMAGE Allows the user to select and load the target image.
% The target image is the image that the final mosaic must reproduce.

    [fileName, filePath] = uigetfile( ...
        {'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, ...
        'Select the target image');

    if isequal(fileName, 0)
        error('No target image selected.');
    end

    targetImage = imread(fullfile(filePath, fileName));

    % Convert grayscale image to RGB if needed
    if size(targetImage, 3) == 1
        targetImage = repmat(targetImage, [1 1 3]);
    end

    % Convert to double in range [0, 1]
    targetImage = im2double(targetImage);

end