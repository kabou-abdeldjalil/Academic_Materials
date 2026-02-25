clc; clear; close all;

%% Q1 : Construction de H 
N = 512;
H = zeros(N,N);

% moyennes [0.5; 0.5]
for j = 1:N/2
    H(2*j-1, j) = 0.5;
    H(2*j,   j) = 0.5;
end

% différences [0.5; -0.5]
for j = 1:N/2
    H(2*j-1, j+N/2) = 0.5;
    H(2*j,   j+N/2) = -0.5;
end

%% Décomposition Haar 2D (1 niveau)

% Charger l'image 
A = imread('buttress.jpg');
A = im2double(im2gray(A));
A = imresize(A,[512 512]);

% Transformée Haar
B = H' * A * H;

% Reconstruction correcte
A_reco = 4 * H * B * H';

% Différence
D = A - A_reco;

% Erreur max
err = max(abs(D(:)));
disp(['Erreur max = ', num2str(err)]);

% Affichage
figure;
subplot(1,3,1);
imshow(A, []); title('Image originale A');

subplot(1,3,2);
imshow(B, []); title('Coefficients Haar B');

subplot(1,3,3);
imshow(A_reco, []); title('Image reconstruite A_reco');


%% Q2 : Décomposition Haar 2D (n niveaux) + reconstruction
clc; clear; close all;

N = 512;
n = 3;   % nombre de niveaux

img = imread('buttress.jpg');
A = im2double(im2gray(img));
A = imresize(A,[N N]);
A0 = A;  

% décomposition : B = H' * A * H sur le bloc LL

for lev = 1:n
    m = N / 2^(lev-1);
    H = zeros(m,m);

    for k = 1:(m/2)
        r1 = 2*k - 1;
        r2 = 2*k;

        H(r1,k) = 0.5;  H(r2,k) = 0.5;
        H(r1,m/2+k) = 0.5;  H(r2,m/2+k) = -0.5;
    end

    A(1:m,1:m) = H' * A(1:m,1:m) * H;
end

B = A;   % coefficients Haar (sur n niveaux)

% reconstruction : A = 4 * H * B * H' (dans l'ordre inverse)

A = B;

for lev = n:-1:1
    m = N / 2^(lev-1);
    H = zeros(m,m);

    for k = 1:(m/2)
        r1 = 2*k - 1;
        r2 = 2*k;

        H(r1,k) = 0.5;  H(r2,k) = 0.5;
        H(r1,m/2+k) = 0.5;  H(r2,m/2+k) = -0.5;
    end

    A(1:m,1:m) = 4 * H * A(1:m,1:m) * H';
end

% vérification
erreur = norm(A0 - A, 'fro');
disp(['Erreur de reconstruction = ', num2str(erreur)]);

% aaffichage
figure;
imshow(B, []);
title(['Coefficients Haar (n = ', num2str(n), ')']);

figure;
subplot(1,2,1), imshow(A0,[]), title('Image originale');
subplot(1,2,2), imshow(A,[]),  title('Image reconstruite');


%%
clc; clear; close all;

% Q3 : Quantification (seuil) + Reconstruction + Distorsion

N = 512;
n = 3;          % nombre de niveaux 
S = 0.02;       % seuil 

img = imread('buttress.jpg');
A0 = im2double(im2gray(img));
A0 = imresize(A0,[N N]);

A = A0;        

% décomposition Haar sur n niveaux

for lev = 1:n
    m = N / 2^(lev-1);
    H = zeros(m,m);

    for k = 1:(m/2)
        r1 = 2*k - 1;
        r2 = 2*k;

        % colonnes passe-bas
        H(r1,k) = 0.5;
        H(r2,k) = 0.5;

        % colonnes passe-haut
        H(r1,m/2+k) = 0.5;
        H(r2,m/2+k) = -0.5;
    end

    A(1:m,1:m) = H' * A(1:m,1:m) * H;
end

A_coeff = A;   % coefficients Haar


% quantification : seuillage des détails (ne pas le bloc LL)

A_q = A_coeff;         % coefficients seuillé
mLL = N / 2^n;         % taille du bloc LL finale

for i = 1:N
    for j = 1:N
        % sseuillage uniquement hors du bloc LL
        if i > mLL || j > mLL
            if abs(A_q(i,j)) < S
                A_q(i,j) = 0;
            end
        end
    end
end

% reconstruction à partir des coefficients seuillés

A = A_q;

for lev = n:-1:1
    m = N / 2^(lev-1);
    H = zeros(m,m);

    for k = 1:(m/2)
        r1 = 2*k - 1;
        r2 = 2*k;

        H(r1,k) = 0.5;
        H(r2,k) = 0.5;

        H(r1,m/2+k) = 0.5;
        H(r2,m/2+k) = -0.5;
    end

    % facteur 4 nécessaire (car filtres = 0.5)
    A(1:m,1:m) = 4 * H * A(1:m,1:m) * H';
end

A_reco = A;   % image reconstruite


%  distorsion (RMSE) + Compression

MSE  = mean((A0(:) - A_reco(:)).^2);
RMSE = sqrt(MSE);
disp(['RMSE = ', num2str(RMSE)]);

CR = nnz(A_coeff) / nnz(A_q);   % compression ratio
disp(['Taux de compression CR = ', num2str(CR)]);


%  Affichage

figure;
subplot(1,3,1), imshow(A0,[]), title('Image originale');
subplot(1,3,2), imshow(A_q,[]), title(['Coefficients seuillés (S=', num2str(S), ')']);
subplot(1,3,3), imshow(A_reco,[]), title('Image reconstruite');

figure;
imshow(abs(A_coeff), []);
title(['Coefficients Haar avant seuil (n = ', num2str(n), ')']);

figure;
imshow(abs(A_q), []);
title(['Coefficients Haar après seuil (n = ', num2str(n), ', S = ', num2str(S), ')']);
