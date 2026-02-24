clear; 
close all; 
clc;

%% Q1

rand('seed', 1);        
N = 2000;
s1 = rand(1, N);
s2 = rand(1, N);

%% Q2

%centrage
s1 = s1 - mean(s1);
s2 = s2 - mean(s2);

%puissance unitaire
s1 = s1 / sqrt(mean(s1.^2));
s2 = s2 / sqrt(mean(s2.^2));

% vérification 
mean(s1); mean(s2); mean(s1.^2); mean(s2.^2)

%% Q3

R = corrcoef(s1, s2);
rho_s = R(1,2)

%% Q4

figure;
plot(s1, s2, '.');
xlabel('s1'); ylabel('s2'); grid on;
title('Nuage de points (s1, s2)');

%% Q5

A = [1 1;
     0.5 1];

S = [s1; s2];   % matrice 2 x 2000
X = A * S;      % mélange

% récupération des observations
x1 = X(1,:);
x2 = X(2,:);

size(X)

%% Q6

Rxx = corrcoef(x1, x2);
rho_x = Rxx(1,2)

figure;
plot(x1, x2, '.');
xlabel('x1'); ylabel('x2'); grid on;
title('Nuage de points (x1, x2)');

%%  II. Blanchiment

% Q1

% vecteur des observations
X = [x1; x2];   
% matrice de covariance de X
Rx = cov(X.'); 
% décomposition en valeurs propres
[E, D] = eig(Rx); % (document Matlab --> e = eig( A ) renvoie un vecteur colonne contenant les valeurs propres de la matrice carrée A)
% Construire la matrice de blanchiment M
M = sqrt(inv(D)) * E';
% Calculer les signaux blanchis
Z = M * X;    
z1 = Z(1,:);
z2 = Z(2,:);

%% Q2 : Vérification (corrélation + variance) et nuage de points

Rzz = corrcoef(z1, z2);
rho_z = Rzz(1,2)

var(z1); var(z2)

figure;
plot(z1, z2, '.');
xlabel('z1'); ylabel('z2'); grid on;
title('Nuage de points après blanchiment');

%% III. Estimation des sources

% Q2
N = size(Z,2);  % Z:signaux blanchi

% initialisation de w avec randn
randn('seed',1);
w = randn(2,1);
w = w / norm(w);   % normalisation

% pour stocker kurtosis
kurt_abs = zeros(20,1);

for k = 1:20
    
    % projection
    y = w' * Z;   % y1(t)

    % calcul du kurtosis
    kurt = mean(y.^4) - 3*(mean(y.^2))^2;
    kurt_abs(k) = abs(kurt);

    % mise à jour de w 
    w = (Z * (y'.^3))/N - 3*w;

    % normalisation
    w = w / norm(w);
end

% source estimé
y1 = w' * Z;

%% Q3
figure;
plot(kurt_abs, 'LineWidth', 1.5);
grid on;
xlabel('itér'); ylabel('kurtosis(y1)');
title('évolution de kurtosis pendant FastICA');

%% Q4

figure;
subplot(3,1,1);
plot(s1); grid on; title('Source originale s1');

subplot(3,1,2);
plot(s2); grid on; title('Source originale s2');

subplot(3,1,3);
plot(y1); grid on; title('Source estimée y1');

% vérification numérique
r1 = corrcoef(y1, s1);
r2 = corrcoef(y1, s2);
corr_y1_s1 = r1(1,2)
corr_y1_s2 = r2(1,2)

%% Q7

% w1 
w1 = w;

% calcul de alpha
alpha = atan( -w1(1) / w1(2) );

% construction de w2
w2 = [cos(alpha); sin(alpha)];

% deuxième source estimée
y2 = w2' * Z;   % 1xN

figure;
subplot(3,1,1); plot(s1); grid on; title('s1(t)');
subplot(3,1,2); plot(s2); grid on; title('s2(t)');
subplot(3,1,3); plot(y2); grid on; title('y2(t) (estimée)');

% corrélations
c21 = corrcoef(y2, s1); corr_y2_s1 = c21(1,2)
c22 = corrcoef(y2, s2); corr_y2_s2 = c22(1,2)

%% Q8

Ryy = corrcoef(y1, y2);
rho_y = Ryy(1,2)

figure;
plot(y1, y2, '.');
xlabel('y1'); ylabel('y2'); grid on;
title('nuage de points (y1, y2)');

%% IV. Mesure de performances de l'algorithme

% Q2 Calcul du RSI

% normalisation puissance unitaire
s1n = s1 / sqrt(mean(s1.^2));
s2n = s2 / sqrt(mean(s2.^2));
y1n = y1 / sqrt(mean(y1.^2));
y2n = y2 / sqrt(mean(y2.^2));

% correction du signe (car corr_y2_s2 ≈ -1)
s1_est = y1n;
s2_est = -y2n;

% calcul RSI
RSI1 = 10*log10( mean(s1n.^2) / mean((s1n - s1_est).^2) );
RSI2 = 10*log10( mean(s2n.^2) / mean((s2n - s2_est).^2) );

RSI = (RSI1 + RSI2)/2;

RSI1
RSI2
RSI

%%
clear; close all; clc;

%% V. Tests avec d'autres signaux

% Q1

% 1) génération des sources (gaussiennes)
randn('seed', 1);
N = 2000;
s1 = randn(1, N);
s2 = randn(1, N);

% 2) centrage + puissance unitaire
s1 = s1 - mean(s1);
s2 = s2 - mean(s2);

s1 = s1 / sqrt(mean(s1.^2));
s2 = s2 / sqrt(mean(s2.^2));

% 3) Corrélation des sources
R = corrcoef(s1, s2);
rho_s = R(1,2)

% 4) Nuage de points (s1,s2)
figure;
plot(s1, s2, '.'); grid on;
xlabel('s1'); ylabel('s2');
title('nuage de points (s1, s2) - "sources gaussiennes"');

% 5) Mélange
A = [1 1; 0.5 1];
S = [s1; s2];
X = A * S;
x1 = X(1,:);
x2 = X(2,:);

% 6) Corrélation des observations
Rxx = corrcoef(x1, x2);
rho_x = Rxx(1,2)

figure;
plot(x1, x2, '.'); grid on;
xlabel('x1'); ylabel('x2');
title('Nuage de points (x1, x2) "mélanges gaussiens"');

% II) Blanchiment
X = [x1; x2];
Rx = cov(X.');
[E, D] = eig(Rx);

M = diag(1 ./ sqrt(diag(D))) * E';
Z = M * X;
z1 = Z(1,:);
z2 = Z(2,:);

% Vérification blanchiment
Rzz = corrcoef(z1, z2);
rho_z = Rzz(1,2)

var_z1 = var(z1)
var_z2 = var(z2)

figure;
plot(z1, z2, '.'); grid on;
xlabel('z1'); ylabel('z2');
title('Nuage de points (z1, z2) "après blanchiment (gaussien)"');

% III) FastICA (kurtosis) - estimation y1
randn('seed', 1);
w = randn(2,1);
w = w / norm(w);

nb_iter = 20;
kurt_abs = zeros(nb_iter,1);

for k = 1:nb_iter
    
    y = w' * Z;  % projection
    
    % kurtosis "excess"
    kurt_val = mean(y.^4) - 3*(mean(y.^2))^2;
    kurt_abs(k) = abs(kurt_val);
    
    % mise à jour point fixe
    w = (Z * (y'.^3))/N - 3*w;
    w = w / norm(w);
end

y1 = w' * Z;

% Courbe du kurtosis
figure;
plot(kurt_abs, 'LineWidth', 1.5);
grid on;
xlabel('itération');
ylabel('kurtosis(y1)');
title('Évolution de kurtosis - "sources gaussiennes"');

% Comparaison y1 avec s1 et s2 (corrélations)
c1 = corrcoef(y1, s1); corr_y1_s1 = c1(1,2)
c2 = corrcoef(y1, s2); corr_y1_s2 = c2(1,2)

figure;
subplot(3,1,1); plot(s1); grid on; title('s1(t) gaussien');
subplot(3,1,2); plot(s2); grid on; title('s2(t) gaussien');
subplot(3,1,3); plot(y1); grid on; title('y1(t) estimé (FastICA)');

%% 
clear; close all; clc;

%% Q2 

% lire les deux fichiers audio
[x1, Fs] = audioread('audio_mix1.wav');
[x2, Fs2] = audioread('audio_mix2.wav');

% écouter les mélanges
soundsc(x1, Fs);
pause(length(x1)/Fs + 1);
soundsc(x2, Fs);
pause(length(x2)/Fs + 1);

% en matrice X
X = [x1.'; x2.'];   % 2 x N
X = X - mean(X,2);  % centrage
N = size(X,2);

% blanchiment
Rx = cov(X.');
[E,D] = eig(Rx);
M = diag(1./sqrt(diag(D))) * E';
Z = M * X;

% FastICA
randn('seed',1);
w = randn(2,1);
w = w / norm(w);

for k = 1:50
    y = w' * Z;
    w = (Z*(y'.^3))/N - 3*w;
    w = w / norm(w);
end

y1 = w' * Z;

% deuxième source (orthogonale)
w2 = [-w(2); w(1)];
y2 = w2' * Z;

% écouter les sources séparées
soundsc(y1.', Fs);
pause(length(y1)/Fs + 1);

soundsc(y2.', Fs);

%% Q3 Images avec FastICA

clear; close all; clc;

% 1) Lire les 2 images 
x1 = im2double(imread('image_mix1.bmp'));
x2 = im2double(imread('image_mix2.bmp'));

% 2) Afficher les mélanges
figure; imshow(x1, []); title('Image mélange 1');
figure; imshow(x2, []); title('Image mélange 2');

% 3) Mettre en matrice X (2 x Npixels)
[H,W] = size(x1);
X = [x1(:)'; x2(:)'];     % 2 x (H*W)
X = X - mean(X,2);        % centrage
N = size(X,2);

% 4) Blanchiment
Rx = cov(X.');
[E,D] = eig(Rx);
M = diag(1./sqrt(diag(D))) * E';
Z = M * X;

% 5) FastICA 
randn('seed',1);
w = randn(2,1);
w = w / norm(w);

for k = 1:50
    y = w' * Z;
    w = (Z*(y'.^3))/N - 3*w;
    w = w / norm(w);
end

y1 = w' * Z;

% 6) Deuxième source 
w2 = [-w(2); w(1)];
y2 = w2' * Z;

% 7) Remettre en image
im1 = reshape(y1, H, W);
im2 = reshape(y2, H, W);

% 8) Afficher les images séparées
figure; imshow(im1, []); title('Image séparée 1 (y1)');
figure; imshow(im2, []); title('Image séparée 2 (y2)');

%% VI. Séparation de plusieurs sources 

% Q2 : la fonction fastica_sym_kurtosis  

% Q3 : 3 sources, mélange avec A, séparation + comparaison + RSI

clear; close all; clc;

rand('seed',1);
N = 2000;

s1 = rand(1,N);
s2 = rand(1,N);
s3 = rand(1,N);

% centrage
s1 = s1 - mean(s1);
s2 = s2 - mean(s2);
s3 = s3 - mean(s3);

% puissance unitaire
s1 = s1 / sqrt(mean(s1.^2));
s2 = s2 / sqrt(mean(s2.^2));
s3 = s3 / sqrt(mean(s3.^2));

S = [s1; s2; s3];   % 3 x N

% mélange avec la matrice A donnée
A = [1 1 1;
     1 1 0.6;
     1 0.7 1];

X = A * S;          % 3 x N

% séparer avec la fonction FastICA symétrique
[Y, W] = fastica_sym_kurtosis(X, 50);   % Y : 3 x N
y1 = Y(1,:);
y2 = Y(2,:);
y3 = Y(3,:);

% comparaison visuellement
figure;
subplot(3,1,1); plot(s1); grid on; title('Source originale s1');
subplot(3,1,2); plot(s2); grid on; title('Source originale s2');
subplot(3,1,3); plot(s3); grid on; title('Source originale s3');

figure;
subplot(3,1,1); plot(y1); grid on; title('Source estimée y1');
subplot(3,1,2); plot(y2); grid on; title('Source estimée y2');
subplot(3,1,3); plot(y3); grid on; title('Source estimée y3');

%% calcul RSI

% normalisation puissance unitaire
Sn = S ./ sqrt(mean(S.^2,2));
Yn = Y ./ sqrt(mean(Y.^2,2));

% matrice des corrélations (3x3)
C = zeros(3,3);
for i = 1:3
    for j = 1:3
        tmp = corrcoef(Yn(i,:), Sn(j,:));
        C(i,j) = tmp(1,2);
    end
end
absC = abs(C)

% matching simple : on prend le max par ligne (suffisant ici)
[~, idx] = max(absC, [], 2);

% construire Shat dans le bon ordre des sources
Shat = zeros(3,N);
for i = 1:3
    j = idx(i);                 % source associée
    Shat(j,:) = sign(C(i,j)) * Yn(i,:);  % bon signe
end

% RSI pour chaque source
RSI1 = 10*log10( mean(Sn(1,:).^2) / mean((Sn(1,:) - Shat(1,:)).^2) );
RSI2 = 10*log10( mean(Sn(2,:).^2) / mean((Sn(2,:) - Shat(2,:)).^2) );
RSI3 = 10*log10( mean(Sn(3,:).^2) / mean((Sn(3,:) - Shat(3,:)).^2) );

RSI = (RSI1 + RSI2 + RSI3)/3;

RSI1, RSI2, RSI3, RSI

%% Q4 : séparation de 9 sources audio

clear; close all; clc;

[x1, Fs] = audioread('melange1.wav');
[x2, Fs] = audioread('melange2.wav');
[x3, Fs] = audioread('melange3.wav');
[x4, Fs] = audioread('melange4.wav');
[x5, Fs] = audioread('melange5.wav');
[x6, Fs] = audioread('melange6.wav');
[x7, Fs] = audioread('melange7.wav');
[x8, Fs] = audioread('melange8.wav');
[x9, Fs] = audioread('melange9.wav');

% construire la matrice X
X = [x1.'; x2.'; x3.'; x4.'; x5.'; x6.'; x7.'; x8.'; x9.'];
X = X - mean(X,2);   % centrage

% on applique FastICA symétrique
[Y, W] = fastica_sym_kurtosis(X, 100);   % 100 itérations

% écouter les sources séparées 
for i = 1:9
    yi = Y(i,:);
    yi = yi / max(abs(yi));   % normalisation pour écouter
    soundsc(yi.', Fs);
    pause(length(yi)/Fs + 1);
end