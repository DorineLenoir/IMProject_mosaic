% 1. Charger les images et les noms des classes
load('cifar-10-batches-mat/data_batch_1.mat'); 
load('cifar-10-batches-mat/batches.meta.mat'); % Contient 'label_names'

% 2. Changez l'index ici pour explorer (entre 1 et 10000)
idx = 1; 

% 3. Reconstruction de l'image
rawImg = data(idx, :);
R = reshape(rawImg(1:1024), 32, 32)';
G = reshape(rawImg(1025:2048), 32, 32)';
B = reshape(rawImg(2049:end), 32, 32)';
img = cat(3, R, G, B);

% 4. Trouver le nom de la catégorie (ex: 'frog', 'bird', 'automobile')
% (+1 car MATLAB commence ses index à 1, alors que les labels vont de 0 à 9)
nomClasse = label_names{labels(idx) + 1};

% 5. Affichage
figure;
imshow(img);
title(['Index: ', num2str(idx), ' | Classe: ', nomClasse]);


[tileLibrary,tileMeans]=preprocessing('cifar-10-batches-mat');
% 3. Petite vérification rapide dans la console
disp('Taille de la bibliothèque de tuiles :');
disp(size(maBibliotheque)); % Doit afficher 50000 x 1

disp('Taille de la matrice des couleurs moyennes :');
disp(size(mesCouleursMoyennes)); % Doit afficher 50000 x 3

% Exemple : Afficher la couleur moyenne RGB de la 1ère tuile
fprintf('Couleur moyenne de la tuile 1 -> R: %.1f, G: %.1f, B: %.1f\n', ...
        mesCouleursMoyennes(1,1), mesCouleursMoyennes(1,2), mesCouleursMoyennes(1,3));