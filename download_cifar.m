function download_cifar()


    url = 'https://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz';
    archiveName = 'cifar-10-matlab.tar.gz';
    targetFolder = 'cifar-10-batches-mat';

    if exist(targetFolder, 'dir')
        fprintf('Dataset is ready. Process skipped.\n');
        return;
    end
    
    try

        websave(archiveName, url);
        untar(archiveName, '.');
        if exist(targetFolder, 'dir')
            fprintf('\nSuccess\n');
        else
            warning('Extraction complete, but the directory "%s" was not found in the root.', targetFolder);
        end
        
        if exist(archiveName, 'file')
            delete(archiveName);
            fprintf('Temporary archive file "%s" removed safely.\n', archiveName);
        end

        
    catch ME
        fprintf('\n[ERROR] Automated download failed.\n');
        fprintf('Reason: %s\n', ME.message);
        fprintf('Please download the file manually at: %s\n', url);
        fprintf('And extract its contents into a folder named "%s" manually.\n', targetFolder);
    end
end
