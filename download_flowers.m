function download_flowers()

    fprintf('=== Flowers Dataset Automation Script ===\n');
    

    targetFolder = 'flowers';
    

    if exist(targetFolder, 'dir')
        fprintf('The directory "%s" already exists.\n', targetFolder);
        fprintf('Flowers dataset is ready. Process skipped.\n===\n');
        return;
    end
    
    try
        fprintf('Downloading Oxford Flowers dataset (~60 MB) from Oxford University...\n');
        fprintf('Please wait, this may take a moment.\n');
        
        url = 'https://www.robots.ox.ac.uk/~vgg/data/flowers/17/17flowers.tgz';
        archiveName = '17flowers.tgz';
  
        websave(archiveName, url);
        fprintf('Extracting images...\n');
        untar(archiveName, '.'); 

        if exist('jpg', 'dir')
            movefile('jpg', targetFolder);
        end

        if exist(archiveName, 'file')
            delete(archiveName);
        end
        
        fprintf('\n=== Success! ===\n');
        fprintf('The folder "%s" is now populated with flower tiles at the project root.\n', targetFolder);
        fprintf('=========================================\n');
        
    catch ME
        fprintf('\n[ERROR] Automated download failed.\n');
        fprintf('Reason: %s\n', ME.message);
        fprintf('Alternative: Please manually add any folder of images named "%s" to the root.\n', targetFolder, targetFolder);
    end
end