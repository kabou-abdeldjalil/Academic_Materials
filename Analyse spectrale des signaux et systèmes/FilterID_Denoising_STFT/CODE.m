%%%1. Étude du filtre
%% Paramètres du filtre

%Q1 --> Traçage de la réponse en fréquence de ce filtre

%Définition des coefficients du numérateur et du dénominateur
num = [1 -0.5 1]; 
den = [1 0 0 -0.729]; 
% Tracé de la réponse en fréquence
freqz(num, den);
title('Réponse en fréquence du filtre');

%%
%Q2 --> Réponse impulsionnelle théorique

% Calcul de la réponse impulsionnelle sur 50 échantillons

P = 50;
h = impz(num, den, P);
%Affichage de h[n]
n = 0:length(h)-1;
figure;
plot(n, h, 'LineWidth', 1.5);
title('Réponse impulsionnelle théorique h[n]');
xlabel('n'); ylabel('Amplitude');
grid on;

% Calcul de la FFT de h[n] 
Hf = fft(h);
f = (0:P-1) / P;
% Affichage du module de la FFT 
figure;
plot(f, abs(Hf), 'LineWidth', 1.5);
xlabel('Fréquence normalisée'); ylabel('|H(f)|');
title('Module de la Transformée de Fourier de h[n]');
grid on;

%% Q5 --> Estimation de la réponse impulsionnelle à partir de données réelles

load('sig.mat');  
N = length(e);

% 1. Estimation des corrélations
Ree = xcorr(e,e, P-1, 'biased');  % Autocorrélation de e[n]
Rse = xcorr(s, e, P-1, 'biased');  % Intercorrélation entre s[n] et e[n]

% 2. Construction de la matrice Gamma avec toeplitz
% La colonne de la matrice Gamma correspond à R_ee(0:P-1)
Gamma = toeplitz(Ree(P:end));

%Le vecteur c contient les valeurs R_se(0:P-1)
c = Rse(P:end);

%3. Résolution du système Gamma * h = c
h_est = Gamma \ c;
%4. Tracé des réponses impulsionnelles estimée et théorique
n = 0:P-1;
figure;
plot(n, h_est, 'b', 'LineWidth', 1.5); hold on;
plot(n, h, 'g--', 'LineWidth', 1.5);
xlabel('n'); ylabel('Amplitude');
title('Réponse impulsionnelle : estimée vs théorique');
legend('h estimée', 'h théorique'); 
grid on;
% 6. Réponse en fréquence estimée via FFT
H_est = fft(h_est);              % Réponse en fréquence estimée
[H_theo, f_theo] = freqz(num, den, 512);  % Réponse en fréquence théorique
f =(0:P-1) / P;   % Axe fréquentiel normalisé [0, 1]
% 7. Tracé du module |H(f)|
N1 = floor(length(H_est)/2) ; 
f1 = (0:N1-1)/N1 ; 
N2 = length(H_theo) ; 
f2 = (0:N2-1)/N2;
figure;
plot(f1, abs(H_est(1:N1, :)), 'b', 'LineWidth', 1.5); hold on;
plot(f2, abs(H_theo), 'r--', 'LineWidth', 1.5);
xlabel('Fréquence normalisée');
ylabel('|H(f)|');
title('Réponse en fréquence : estimée vs théorique');
legend('|H_{estimée}(f)|', '|H_{théorique}(f)|');
grid on;

%% Q8 – Estimation de la réponse fréquentielle
load('sig.mat');
    
% 1. Calcul des FFTs des signaux sur la même longueur
E = fft(e);
S = fft(s);

% 3. Densités spectrales estimées
S_se = S .* conj(E);     % Inter-spectre sortie/entrée
S_ee = E .* conj(E);     % Spectre de puissance de e[n]

% 4. Réponse en fréquence estimée par méthode fréquentielle
H_est_f = S_se ./ (S_ee + 1e-8);  % On ajoute un petit terme pour éviter les divisions par 0

% 5. Comparaison des modules |H(f)|
[H_theo_long, ~] = freqz(num, den, N);
N3 = floor(length(H_est_f)/2) ;
f3 = (0:N3-1)/N3;
N4 = length(H_theo_long) ; 
f4 = (0:N4-1)/N4;

figure;
plot(f3, abs(H_est_f(1:N3, :)), 'b', 'LineWidth', 1.5); hold on;
plot(f4, abs(H_theo_long), 'r--', 'LineWidth', 1.5);
xlabel('Fréquence normalisée');
ylabel('|H(f)|');
title('Réponse en fréquence (fréquentielle) vs théorique');
legend('|H_{est\_freq}(f)|', '|H_{théorique}(f)|');
grid on;

% 6. Estimation de la réponse impulsionnelle h[n] par IFFT
h_est_freq = ifft(H_est_f);  % Transformation inverse
h_est_freq = h_est_freq(1:P);      % On garde P coefficients pour comparer
H_theo = impz(num, den, P);

% 7. Tracé des réponses impulsionnelles
n = 0:P-1;
figure;
plot(n, h_est_freq, 'b', 'LineWidth', 1.5); hold on;
plot(n, H_theo, 'r--', 'LineWidth', 1.5);
xlabel('n');
ylabel('Amplitude');
title('Réponse impulsionnelle : méthode fréquentielle vs théorique');
legend('h_{est\_freq}', 'h théorique');
grid on;


%% application biomédicale:

%1. Chargement des données
% Charger les données
load('estim.mat');  % contient : mes, ref, sig

% Affichage des signaux (optionnel)
figure;
subplot(3,1,1); plot(mes); title('Signal mesuré (foetus + bruit)');
subplot(3,1,2); plot(ref); title('Référence de bruit');
subplot(3,1,3); plot(sig); title('Signal original du foetus (référence)');

% 2. Estimation de la réponse impulsionnelle h[n]

% Calcul des corrélations
R_ref = xcorr(ref, P - 1, 'biased');
R_mesref = xcorr(mes, ref, P - 1, 'biased');
% Construction de la matrice Toeplitz Γ et du vecteur c
mid = P;  % indice central
gamma = toeplitz(R_ref(mid:mid+P-1));  % Γ de taille P x P
c = R_mesref(mid:mid+P-1)';            % vecteur c (colonne)
% Résolution du système Γ * h = c
h_hat = gamma .\ c;
% Affichage de la réponse impulsionnelle estimée
figure;
stem(0:P-1, h_hat, 'filled');
title('Réponse impulsionnelle estimée h[n]');
xlabel('n'); ylabel('Amplitude');
grid on;


%3. Débruitage du signal
% Reconstitution du bruit estimé
d_hat = conv(ref, h_hat,'same');
d_hat = d_hat(1:length(mes));  % ajuster la taille
sig = sig(1:N);
% Signal débruité estimé
sig_hat = mes - d_hat;

% Affichage
figure; subplot(2,1,1);
plot(sig); title('Signal foetal original (référence)');
subplot(2,1,2);
plot(sig_hat); title('Signal foetal estimé (débruité)');

%4. Évaluation visuelle et conclusion
% Évaluation quantitative
RMSE = sqrt(mean((sig - sig_hat).^2));
disp(['Erreur quadratique moyenne (RMSE) = ', num2str(RMSE)]);

%%
%Application audio:
clear; clc; close all;
%1. Charger les signaux audio
[z2, Fe1] = audioread('z2.wav');   % signal bruité (micro A)
[b2, Fe2] = audioread('b2.wav');   % référence de bruit (micro B)
% Vérification de la fréquence d’échantillonnage
if Fe1 ~= Fe2
    error('Les fichiers audio n''ont pas la même fréquence d''échantillonnage.');
end

Fe = Fe1;
% Troncature à la même longueur (au cas où)
N = min(length(z2), length(b2));
z2 = z2(1:N);
b2 = b2(1:N);

%2. Paramètre du filtre
P = 300;  % ordre du filtre à estimer

%3. Estimation de la réponse impulsionnelle h[n]
% Corrélations estimées (biaisées)
R_b = xcorr(b2, P - 1, 'biased');
R_zb = xcorr(z2, b2, P - 1, 'biased');

% Construction du système Γh = c
mid = P;
Gamma = toeplitz(R_b(mid:mid+P-1));
c = R_zb(mid:mid+P-1);

% Résolution du système
h_hat = Gamma \ c;

% Affichage du filtre estimé
figure;
stem(0:P-1, h_hat, 'filled');
title('Réponse impulsionnelle estimée h[n]');
xlabel('n'); ylabel('Amplitude');

%4. Reconstruction du bruit
d_hat = conv(b2, h_hat);
d_hat = d_hat(1:N);  % Ajuster la longueur

%5. Estimation du signal utile
sig_hat = z2 - d_hat;

%6. Écoute des signaux
disp('Lecture du signal original (pollué)...');
sound(z2, Fe); pause(length(z2)/Fe + 1);

disp('Lecture du signal estimé (après débruitage)...');
sound(sig_hat, Fe);

%7. Sauvegarde optionnelle 
audiowrite('signal_debruite.wav', sig_hat, Fe);
disp('Signal utile estimé sauvegardé dans signal_debruite.wav');


%%   Analyse temps-fréquence



% Paramètres
Fe = 8000;  % Fréquence d'échantillonnage en Hz
N = 1024;   % Nombre d'échantillons
n = 0:N-1;  % Axe temporel
x = zeros(1, N);
x(N/2) = 1; % Impulsion de Kronecker au centre

% Fenêtres à tester
windows = {hamming(128), rectwin(128), blackman(128), hann(128)};
window_names = {'Hamming', 'Rectangulaire', 'Blackman', 'Hann'};

% Affichage des spectrogrammes
figure;
for i = 1:length(windows)
    subplot(2,2,i);
    spectrogram(x, windows{i}, 64, 256, Fe, 'yaxis');
    title(['Spectrogramme avec ', window_names{i}]);
    xlabel('Temps (s)');
    ylabel('Fréquence (Hz)');
    colorbar;
end

%%

% Paramètres du signal
Fe = 8000;  % Fréquence d'échantillonnage (Hz)
N = 2048;   % Nombre total d'échantillons
t = (0:N-1)/Fe;  % Axe temporel

% Génération d'une sinusoïde avec fréquence variable
f1 = 300;   % Fréquence initiale (Hz)
f2 = 1200;  % Fréquence finale (Hz)
x = cos(2*pi * (f1 + (f2-f1) * (t/(2*max(t)))) .* t);

% Fenêtres à tester
windows = {hamming(256), rectwin(256), blackman(256), hann(256)};
window_names = {'Hamming', 'Rectangulaire', 'Blackman', 'Hann'};

% Tracé des spectrogrammes
figure;
for i = 1:length(windows)
    subplot(2,2,i);
    spectrogram(x, windows{i}, 128, 512, Fe, 'yaxis');
    title(['Spectrogramme avec ', window_names{i}]);
    xlabel('Temps (s)');
    ylabel('Fréquence (Hz)');
    colorbar;
end

%%


% Paramètres
Fe = 8000;   % Fréquence d'échantillonnage (Hz)
N = 4096;    % Nombre total d'échantillons
t = (0:N-1)/Fe;  % Axe temporel

% Création du signal
x = zeros(1, N);

% 1. Sinusoïdes continues (fréquences pures)
x = x + cos(2*pi*500*t);   % Fréquence 500 Hz
x = x + cos(2*pi*1500*t);  % Fréquence 1500 Hz

% 2. Événements ponctuels (impulsions)
x(1000) = 5;   % Impulsion à t = 1000 échantillons
x(2000) = -5;  % Impulsion à t = 2000 échantillons
x(3000) = 3;   % Impulsion à t = 3000 échantillons

% Fenêtres à tester
windows = {hamming(256), rectwin(256), blackman(256), hann(256)};
window_names = {'Hamming', 'Rectangulaire', 'Blackman', 'Hann'};

% Tracé des spectrogrammes
figure;
for i = 1:length(windows)
    subplot(2,2,i);
    spectrogram(x, windows{i}, 128, 512, Fe, 'yaxis');
    title(['Spectrogramme avec ', window_names{i}]);
    xlabel('Temps (s)');
    ylabel('Fréquence (Hz)');
    colorbar;
end

%%

% Paramètres généraux
Fe = 8000;    % Fréquence d'échantillonnage (Hz)
N = 4096;     % Nombre d'échantillons
t = (0:N-1)/Fe; % Axe temporel

% 1. Signal CHIRP (fréquence qui varie avec le temps)
chirp_signal = chirp(t, 200, max(t), 2000, 'linear');  

% 2. Sinusoïdes par morceaux
sinus_piecewise = zeros(1, N);
sinus_piecewise(1:N/3)   = cos(2*pi*300*t(1:N/3));   % 300 Hz
sinus_piecewise(N/3+1:2*N/3) = cos(2*pi*800*t(N/3+1:2*N/3)); % 800 Hz
sinus_piecewise(2*N/3+1:end) = cos(2*pi*1500*t(2*N/3+1:end)); % 1500 Hz

% 3. Signal bruité (sinusoïde avec du bruit blanc)
sinus_bruite = cos(2*pi*600*t) + 0.5*randn(size(t));

% Tracé des spectrogrammes
figure;

subplot(3,1,1);
spectrogram(chirp_signal, hamming(256), 128, 512, Fe, 'yaxis');
title('Spectrogramme du CHIRP');

subplot(3,1,2);
spectrogram(sinus_piecewise, hamming(256), 128, 512, Fe, 'yaxis');
title('Spectrogramme des sinusoïdes par morceaux');

subplot(3,1,3);
spectrogram(sinus_bruite, hamming(256), 128, 512, Fe, 'yaxis');
title('Spectrogramme du signal bruité');


%%

% 1. Chargement du signal audio
[gong, Fe] = audioread('gong.wav');  % Charger un fichier audio
N = length(gong);   % Nombre d'échantillons
t = (0:N-1) / Fe;     % Axe temporel

% 2. Affichage du signal dans le domaine temporel
figure;
subplot(3,1,1);
plot(t, gong);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Représentation temporelle du signal');

% 3. Transformée de Fourier (TFD)
f = (-N/2:N/2-1)*(Fe/N);  % Axe des fréquences
TF_signal = fftshift(fft(gong));  % FFT centrée
subplot(3,1,2);
plot(f, abs(TF_signal));
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre en fréquence du signal');

% 4. Spectrogramme
subplot(3,1,3);
spectrogram(gong, hamming(256), 128, 512, Fe, 'yaxis');
title('Spectrogramme du signal');
