image = imread('aquitaine.png');
figure;
subplot(3,2,1);
imshow(image);
title('Image originale');
subplot(3,2,2);
imhist(image);
title("Histogramme de l'image originale");
subplot(3,2,[3.5,3.6]);
imagesc(image);
title('Image originale')
image_modifiee = image + 100;
image_modifiee(image_modifiee>255) = 255; %ou min(image_modifiee = min(image+100,255));
subplot(3,2,5);
imshow(image_modifiee)
title('Image modifiée')
subplot(3,2,6);
imhist(image_modifiee);
title("Histogramme de l'image modifiée");
******************************************************************************************************************
image_2 = imread('lena.png');
subplot(2,2,1);
imshow(image_2)
title('Image originale');
subplot(2,2,2);
imhist(image_2)
title("Histogramme de l'image originale");
image_modifiee_2 = image_2 ./ 8;
subplot(2,2,3);
imshow(image_modifiee_2)
title('Image modifiée')
subplot(2,2,4);
imhist(image_modifiee_2);
title("Histogramme de l'image modifiée");
******************************************************************************************************************
image_3 = imread('micro1.png');
subplot(3,2,1)
imshow(image_3)
title('Image originale');
subplot(3,2,2)
imhist(image_3)
title("Histogramme de l'image originale");
%Normalisation de l'image
img_min = double(min(image_3(:)));
img_max = double(max(image_3(:)));
image_normalisee = uint8(255*(double(image_3)-img_min)/(img_max-img_min));
subplot(3,2,3)
imshow(image_normalisee)
title('Image normalisée');
subplot(3,2,4)
imhist(image_normalisee)
title("Histogramme de l'image normalisée");
%Egalisation de l'image
image_egalise = histeq(image_3);
subplot(3,2,5)
imshow(image_egalise)
title('Image Egalisée');
subplot(3,2,6)
imhist(image_egalise)
title("Histogramme de l'image égalisée");
*******************************************************************************************************************
largeur = 10;
hauteur = 10;
image_noire = zeros(hauteur,largeur);
image_noire(3:8,3:8)=255;
subplot(2,2,1)
imshow(image_noire)
title('Carré blanc sur fond noir');
**************************************************************************************************************************
% Fonction de convolution
function resultImage = applyConvolution(image, filter)
    [hauteur, largeur] = size(image);
    resultImage = zeros(hauteur, largeur);
    
    for i = 2:hauteur-1
        for j = 2:largeur-1
            region = image(i-1:i+1, j-1:j+1); % Extraire la région 3x3 autour du pixel
            resultImage(i, j) = sum(sum(region .* filter)); % Appliquer le filtre
        end
    end
end

% Programme principal
% Création d'une image carrée (par exemple, un carré blanc au centre sur fond noir)
image = zeros(7, 7);    
image(2:6, 2:6) = 255; 

% Définition des filtres de gradient
filtre_x = [0 0 0; -1 0 1; 0 0 0];  % Filtre pour le gradient horizontal
filtre_g = [0 -1 0; 0 0 0; 0 1 0];  % Filtre pour le gradient diagonal

% Convolution avec les filtres
image_x = applyConvolution(image, filtre_x);
image_g = applyConvolution(image, filtre_g);

% Calcul de la norme du gradient (combinaison des deux convolutions)
norme_gradient = sqrt(image_x.^2 + image_g.^2);

% Affichage des résultats
subplot(2,2,1), imshow(image), title('Image originale')
subplot(2,2,2), imshow(image_x), title('Gradient horizontal (filtre\_x)')
subplot(2,2,3), imshow(image_g), title('Gradient diagonal (filtre\_g)')
subplot(2,2,4), imshow(norme_gradient), title('Norme du gradient')

*******************************************************************************************************
% Fonction de convolution
function resultImage = applyConvolution(image, filter)
    [hauteur, largeur] = size(image);
    resultImage = zeros(hauteur, largeur);
    
    for i = 2:hauteur-1
        for j = 2:largeur-1
            region = image(i-1:i+1, j-1:j+1); % Extraire la région 3x3 autour du pixel
            resultImage(i, j) = sum(sum(region .* filter)); % Appliquer le filtre
        end
    end
end

% Programme principal
% Création d'une image carrée (par exemple, un carré blanc au centre sur fond noir)
image = zeros(7, 7);    
image(2:6, 2:6) = 255; 

% Définition des filtres de gradient
filtre_x = [0 0 0; -1 0 1; 0 0 0];  % Filtre pour le gradient horizontal
filtre_g = [0 -1 0; 0 0 0; 0 1 0];  % Filtre pour le gradient diagonal

% Convolution avec les filtres
image_x = applyConvolution(image, filtre_x);
image_g = applyConvolution(image, filtre_g);

% Calcul de la norme du gradient (combinaison des deux convolutions)
norme_gradient = sqrt(image_x.^2 + image_g.^2);

% Afficher les valeurs négatives
image_x = abs(image_x);
image_g = abs(image_g);

% Affichage des résultats
subplot(2,2,1), imshow(image), title('Image originale')
subplot(2,2,2), imshow(image_x), title('Gradient horizontal (filtre\_x)')
subplot(2,2,3), imshow(image_g), title('Gradient diagonal (filtre\_g)')
subplot(2,2,4), imshow(norme_gradient), title('Norme du gradient')

*****************************************************************************************************
% Fonction de convolution
function resultImage = applyConvolution(image, filter)
    [hauteur, largeur] = size(image);
    resultImage = zeros(hauteur, largeur);
    
    for i = 2:hauteur-1
        for j = 2:largeur-1
            region = image(i-1:i+1, j-1:j+1); % Extraire la région 3x3 autour du pixel
            resultImage(i, j) = sum(sum(region .* filter)); % Appliquer le filtre
        end
    end
end

% Programme principal
% Charger l'image cameraman
image = imread('cameraman.pgm');
image = double(image);  % Conversion en double pour permettre les calculs
% Définition des filtres de gradient
filtre_x = [0 0 0; -1 0 1; 0 0 0];  % Filtre pour le gradient horizontal
filtre_g = [0 -1 0; 0 0 0; 0 1 0];  % Filtre pour le gradient diagonal

% Convolution avec les filtres
image_x = applyConvolution(image, filtre_x);
image_g = applyConvolution(image, filtre_g);

% Calcul de la norme du gradient (combinaison des deux convolutions)
norme_gradient = sqrt(image_x.^2 + image_g.^2);

% Afficher les valeurs négatives
image_x = abs(image_x);
image_g = abs(image_g);

% Affichage des résultats
subplot(2,2,1), imshow(uint8(image)), title('Image originale')
subplot(2,2,2), imshow(uint8(image_x)), title('Gradient horizontal (filtre\_x)')
subplot(2,2,3), imshow(uint8(image_g)), title('Gradient diagonal (filtre\_g)')
subplot(2,2,4), imshow(uint8(norme_gradient)), title('Norme du gradient')


*******************************************************************************************************
% Charger l'image originale
image = imread('cameraman.pgm');
image = double(image); 
% Ajouter du bruit blanc gaussien
sigma = 25; % Définir la variance du bruit
bruit = sigma * randn(size(image));
image_bruitee = image + bruit;
image_bruitee(image_bruitee > 255) = 255;
image_bruitee(image_bruitee < 0) = 0;
%Afficher l'image originale et l'image bruitée
figure;
subplot(2, 2, 1);
imshow(uint8(image), []);
title('Image originale');
subplot(2, 2, 2);
imshow(uint8(bruit),[]);
title('Bruit');
subplot(2, 2, [3 4]);
imshow(uint8(image_bruitee),[]);
title('Image bruitée');

***********************************************************************************************************************
% Fonction de convolution
function resultImage = applyConvolution(image, filter)
    [hauteur, largeur] = size(image);
    resultImage = zeros(hauteur, largeur);
    
    for i = 2:hauteur-1
        for j = 2:largeur-1
            region = image(i-1:i+1, j-1:j+1); % Extraire la région 3x3 autour du pixel
            resultImage(i, j) = sum(sum(region .* filter)); % Appliquer le filtre
        end
    end
end

image = imread('cameraman.pgm');
image = double(image); 
sigma = 25;
bruit = sigma * randn(size(image));
image_bruitee = image + bruit;
image_bruitee(image_bruitee > 255) = 255;
image_bruitee(image_bruitee < 0) = 0;

filtre_Sx = [-1 0 1; -2 0 2; -1 0 1];  % Filtre de Sobel en x
filtre_Sy = [-1 -2 -1; 0 0 0; 1 2 1];  % Filtre de Sobel en y

image_x = applyConvolution(image, filtre_Sx);
image_g = applyConvolution(image, filtre_Sy);
image_bruitee_x = applyConvolution(image_bruitee, filtre_Sx);
image_bruitee_g = applyConvolution(image_bruitee, filtre_Sy);

% gradient pour les images d'origine et bruitée
gradient_image = sqrt(image_x.^2 + image_g.^2);
gradient_image_bruite = sqrt(image_bruitee_x.^2 + image_bruitee_g.^2);

subplot(3, 3, 1);
imshow(uint8(image), []);
title('Image originale');

subplot(3, 3, 2);
imshow(uint8(image_bruitee), []);
title('Image bruitée');

subplot(3, 3, 3);
imshow(uint8(image_x), []);
title('Sobel X - Image originale');

subplot(3, 3, 4);
imshow(uint8(image_bruitee_x), []);
title('Sobel X - Image bruitée');

subplot(3, 3, 5);
imshow(uint8(image_g), []);
title('Sobel Y - Image originale');

subplot(3, 3, 6);
imshow(uint8(image_bruitee_g), []);
title('Sobel Y - Image bruitée');

subplot(3, 3, 7);
imshow(uint8(gradient_image), []);
title('Gradient - Image originale');

subplot(3, 3, 8);
imshow(uint8(gradient_image_bruite), []);
title('Gradient - Image bruitée');
*******************************************************************************************************
% Fonction de convolution
function resultImage = applyConvolution(image, filter)
    [hauteur, largeur] = size(image);
    resultImage = zeros(hauteur, largeur);
    
    for i = 2:hauteur-1
        for j = 2:largeur-1
            region = image(i-1:i+1, j-1:j+1); % Extraire la région 3x3 autour du pixel
            resultImage(i, j) = sum(sum(region .* filter)); % Appliquer le filtre
        end
    end
end

image = imread('cameraman.pgm');
image = double(image); 
sigma = 25;
bruit = sigma * randn(size(image));
image_bruitee = image + bruit;
image_bruitee(image_bruitee > 255) = 255;
image_bruitee(image_bruitee < 0) = 0;

filtre_Sx = [-1 0 1; -2 0 2; -1 0 1];  % Filtre de Sobel en x
filtre_Sy = [-1 -2 -1; 0 0 0; 1 2 1];  % Filtre de Sobel en y

image_x = applyConvolution(image, filtre_Sx);
image_g = applyConvolution(image, filtre_Sy);
image_bruitee_x = applyConvolution(image_bruitee, filtre_Sx);
image_bruitee_g = applyConvolution(image_bruitee, filtre_Sy);

% gradient pour les images d'origine et bruitée
gradient_image = sqrt(image_x.^2 + image_g.^2);
gradient_image_bruite = sqrt(image_bruitee_x.^2 + image_bruitee_g.^2);

seuil = 50;
contours_image = gradient_image > seuil;
contours_image_bruite = gradient_image_bruite > seuil;


subplot(2,2,1);
imshow(uint8(gradient_image), []);
title('Gradient - Image originale');

subplot(2,2,2);
imshow(uint8(gradient_image_bruite), []);
title('Gradient - Image bruitée');

subplot(2,2,3);
imshow(uint8(contours_image), []);
title('Contours - Image originale');

subplot(2,2,4);
imshow(uint8(contours_image_bruite), []);
title('Contours - Image bruitée');

