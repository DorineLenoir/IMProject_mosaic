function targetImage = loadTargetImage()
%Allows the user to select and load the target image.
% The target image is the image that the final mosaic must reproduce.

    [fileName, filePath] = uigetfile( ...
        {'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, ...
        'Select the target image');

    if isequal(fileName, 0)
        error('No target image selected.');
    end

    targetImage = imread(fullfile(filePath, fileName));

    if size(targetImage, 3) == 1
        targetImage = repmat(targetImage, [1 1 3]);
    end

    targetImage = im2double(targetImage);

end