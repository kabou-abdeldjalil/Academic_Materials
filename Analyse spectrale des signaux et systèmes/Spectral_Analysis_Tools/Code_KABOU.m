clear; close all; clc;

% Paramètres
fe = 1000;               % Fe
N = 100;                 % Nombre d'échantillons
T = 1/fe;                % Période d'échantillonnage
t = (0:N-1) * T;         % Vecteur temps
 
%f0 = 100;                % Fréquence de la sinusoïde
f0 = 95; 

% signal sinusoïdal
x = cos(2 * pi * f0 * t);

% Calcul de la TFD
X = fft(x);            % TFD
f = (0:N-1) * (fe/N);  % Axe des fréquences

% Affichage du signal temporel
subplot(2,1,1);
plot(t, x, 'b', 'LineWidth', 1.5);
xlabel('Temps (s)'); ylabel('Amplitude');
title(['Signal sinusoïdal f_0 = ', num2str(f0), ' Hz']);
grid on;

% Affichage de la TFD (Module)
subplot(2,1,2);
stem(f, abs(X) / (N/2), 'r', 'filled');
xlabel('Fréquence (Hz)'); ylabel('|X(f)|');
title('Module de la Transformée de Fourier Discrète (TFD)');
grid on;

% Indice du pic spectral (k0)
[~, k0] = max(abs(X)); 
% Phase à l’origine
phi = angle(X(k0)); 
% Affichage de la phase
disp(['Phase initiale estimée: ', num2str(phi), ' radians']);

Amplitude_reelle = 1;   % Amplitude réelle
% Amplitude estimée
X_mag = abs(X) / N;
Amplitude_estimee = 2 * X_mag(k0); % Facteur 2 psq FFT donne une demi-amplitude
% Calcul de l'erreur relative
erreur_relative = abs(Amplitude_reelle - Amplitude_estimee) / Amplitude_reelle;

% Affichage
disp(['Amplitude réelle : ', num2str(1)]);
disp(['Amplitude estimée : ', num2str(Amplitude_estimee)]);
disp(['Erreur relative : ', num2str(erreur_relative * 100), ' %']);

%%
% un signal 10 fois plus long que le précédent

N0 = 10 * N;              % Nombre d'échantillons avec zero-padding
A = 1;                    % Amplitude du signal
%f0 = 100;                % Fréquence du signal
f0 = 95;

% Signal original
x = A * cos(2 * pi * f0 * t);

% Zero-padding
zero_padding = [x, zeros(1, N0 - N)];    %zeros(m,n) donc il est vecteur ligne

% TFD du signal original
X = fft(x);
f = (0:N-1) * (fe / N);

% TFD du signal avec zero-padding
TF_zero_padding = fft(zero_padding);
LaTF_zero_padding = (0:N0-1) * (fe / N0);

% Affichage des spectres
figure;
plot(f, abs(X)/(N/2), 'r-o', 'LineWidth', 1.5); hold on;
plot(LaTF_zero_padding, abs(TF_zero_padding)/(N/2), 'b-', 'LineWidth', 1.2);
title('Spectre de la sinusoïde f_0 = 95 Hz');
xlabel('Fréquence (Hz)'); ylabel('|TFD|');
legend('TFD (N=95)', 'TFD (N0=10N)');
grid on;

%%  Fenêtrage

%qs3 et 4
clear; close all; clc;

% Paramètres
N = 100;         
N0 = 1024;       % Longueur après bourrage de zéros (pour meilleure résolution)

% Fenêtres
w_rect = ones(N, 1);          % Fenêtre rectangulaire
w_hann = hann(N);             % Fenêtre de Hanning

% Bourrage de zéros
w_rect_padded = [w_rect; zeros(N0 - N, 1)];
w_hann_padded = [w_hann; zeros(N0 - N, 1)];

% Calcul de la TFD
W_rect = abs(fft(w_rect_padded));  
W_hann = abs(fft(w_hann_padded));  

% Normalisation
W_rect = W_rect / max(W_rect);
W_hann = W_hann / max(W_hann);

% Axe fréquentiel
f = linspace(0, 1, N0);  % Normalisé à la fréquence d'échantillonnage

% Affichage
figure;
semilogy(f, W_rect(1:N0), 'r', 'LineWidth', 1.5); hold on;
semilogy(f, W_hann(1:N0), 'b', 'LineWidth', 1.5);
xlabel('Fréquence normalisée');
ylabel('Amplitude (dB)');
legend('Fenêtre Rectangulaire', 'Fenêtre de Hanning');
title('Réponse en fréquence des fenêtres');
grid on;


%%  Question 5

% Paramètres
Fe = 1000;       % Fréquence d'échantillonnage (Hz)
N = 100;         % Nombre d'échantillons
t = (0:N-1)/Fe;  % Axe temporel
f0_1 = 100;      % Fréquence de la sinusoïde (cas 1)
f0_2 = 95;       % Fréquence de la sinusoïde (cas 2)

% Création des sinusoïdes
x1 = cos(2*pi*f0_1*t);  
x2 = cos(2*pi*f0_2*t);

% Fenêtres (normalisées)
w_rect = ones(N, 1) / sum(ones(N, 1));  % Rectangulaire
w_hann = hann(N) / sum(hann(N));        % Hanning

% Application des fenêtres
x1_rect = x1 .* w_rect';
x1_hann = x1 .* w_hann';

x2_rect = x2 .* w_rect';
x2_hann = x2 .* w_hann';

% TFD et normalisation
X1_rect = abs(fft(x1_rect, 1024));
X1_hann = abs(fft(x1_hann, 1024));

X2_rect = abs(fft(x2_rect, 1024));
X2_hann = abs(fft(x2_hann, 1024));

% Fréquence normalisée
f = linspace(0, Fe/2, 512);  % On ne garde que la moitié (positif)

% Affichage des résultats
figure;
subplot(2,1,1);
plot(f, X1_rect(1:512), 'r', 'LineWidth', 1.5); hold on;
plot(f, X1_hann(1:512), 'b', 'LineWidth', 1.5);
xlabel('Fréquence (Hz)'); ylabel('Amplitude');
title('TFD du signal pour f_0 = 100 Hz');
legend('Fenêtre Rectangulaire', 'Fenêtre de Hanning');
grid on;

subplot(2,1,2);
plot(f, X2_rect(1:512), 'r', 'LineWidth', 1.5); hold on;
plot(f, X2_hann(1:512), 'b', 'LineWidth', 1.5);
xlabel('Fréquence (Hz)'); ylabel('Amplitude');
title('TFD du signal pour f_0 = 95 Hz');
legend('Fenêtre Rectangulaire', 'Fenêtre de Hanning');
grid on;

%% Question 6

% Paramètres
Fs = 1000;  % Fréquence d'échantillonnage (Hz)
N = 100;    % Nombre d'échantillons
t = (0:N-1)/Fs; % Axe temporel
A = 1;      % Amplitude de la sinusoïde
f0 = 95;    % Fréquence de la sinusoïde (tester aussi avec 100 Hz)

% Génération du signal sinusoïdal
x = A * cos(2 * pi * f0 * t);

% Appliquer les fenêtres
w_rect = ones(1, N); % Fenêtre rectangulaire
w_hann = hann(N)';   % Fenêtre de Hanning

% Signal fenêtré
x_rect = x .* w_rect;
x_hann = x .* w_hann;

% Calcul des TFD
X_rect = abs(fft(x_rect)); % TFD fenêtre rectangulaire
X_hann = abs(fft(x_hann)); % TFD fenêtre de Hanning

% Normalisation (facteur 2/N pour conserver amplitude correcte)
X_rect = 2 * X_rect / N;
X_hann = 2 * X_hann / sum(w_hann); % Normalisation pour fenêtre de Hanning

% Axe des fréquences
f = (0:N-1) * Fs / N;

% Trouver l'amplitude maximale dans le spectre
[max_rect, idx_rect] = max(X_rect(1:N/2)); % Fenêtre rectangulaire
[max_hann, idx_hann] = max(X_hann(1:N/2)); % Fenêtre de Hanning

% Calcul des erreurs relatives en amplitude
err_rect = abs((max_rect - A) / A) * 100; % En pourcentage
err_hann = abs((max_hann - A) / A) * 100;

% Affichage des résultats
fprintf('Fenêtre Rectangulaire : Amplitude max = %.4f, Erreur relative = %.2f%%\n', max_rect, err_rect);
fprintf('Fenêtre de Hanning   : Amplitude max = %.4f, Erreur relative = %.2f%%\n', max_hann, err_hann);

% Affichage des spectres
figure;
subplot(2,1,1);
plot(f(1:N/2), X_rect(1:N/2), 'b', 'LineWidth', 1.5); hold on;
plot(f(idx_rect), max_rect, 'ro', 'MarkerFaceColor', 'r');
title('TFD avec Fenêtre Rectangulaire');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(f(1:N/2), X_hann(1:N/2), 'r', 'LineWidth', 1.5); hold on;
plot(f(idx_hann), max_hann, 'bo', 'MarkerFaceColor', 'b');
title('TFD avec Fenêtre de Hanning');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
grid on;

%%   Résolution spectrale 

% Paramètres du signal
Fe = 1000;      % Fréquence d'échantillonnage (Hz)
N = 100;        % Nombre d'échantillons
t = (0:N-1)/Fe; % Axe temporel

% Paramètres des sinusoïdes
A1 = 1; f1 = 95;      % Première sinusoïde
A2 = 1; f2 = 140;     % Deuxième sinusoïde (modifiable)

% Création du signal
phi1 = 0; phi2 = 0;  % Phases
x = A1*sin(2*pi*f1*t + phi1) + A2*sin(2*pi*f2*t + phi2);

% Fenêtres
rect_window = ones(N,1);        % Fenêtre rectangulaire
hann_window = hann(N);          % Fenêtre de Hanning

% Application des fenêtres
x_rect = x .* rect_window';
x_hann = x .* hann_window';

% TFD
NFFT = 1024; % Zero-padding pour plus de précision
X_rect = abs(fft(x_rect, NFFT)); 
X_hann = abs(fft(x_hann, NFFT));

% Axe des fréquences
freqs = (0:NFFT-1)*(Fe/NFFT);

% Normalisation pour retrouver l'amplitude max
X_rect = X_rect / max(X_rect);
X_hann = X_hann / max(X_hann);

% Affichage des spectres
figure;
subplot(2,1,1);
plot(freqs, X_rect, 'b', 'LineWidth', 1.5);
xlabel('Fréquence (Hz)'); ylabel('Amplitude normalisée');
title('TFD avec fenêtre rectangulaire'); grid on; xlim([0, Fe/2]);

subplot(2,1,2);
plot(freqs, X_hann, 'r', 'LineWidth', 1.5);
xlabel('Fréquence (Hz)'); ylabel('Amplitude normalisée');
title('TFD avec fenêtre de Hanning'); grid on; xlim([0, Fe/2]);

%%  Partie Aléatoire

% Paramètres
N = 50;  % Nombre d'échantillons par réalisation
M = 100; % Nombre de réalisations
% Initialisation des matrices pour stocker les autocorrélations estimées
au_biaise = zeros(2*N-1, M);
au_non_biaise = zeros(2*N-1, M);

% Génération des signaux et calcul des autocorrélations
for i = 1:M
    B = randn(1, N);    % Bruit blanc 
    X = B + 1;          % Signal X1[n]
    % Autocorrélation biaisée et non biaisée avec xcorr
    [bisaie, lags] = xcorr(X, 'biased');
    [non_biaise, ~] = xcorr(X, 'unbiased');
    % Stockage des résultats
    au_biaise(:, i) = bisaie;
    au_non_biaise(:, i) = non_biaise;
end

% Moyenne et variance des estimateurs
moyenne_es_biaise = mean(au_biaise, 2);
moyenne_es_non_biaise = mean(au_non_biaise, 2);

var_es_biaise = var(au_biaise, 0, 2);
var_es_non_biaise = var(au_non_biaise, 0, 2);

% Affichage des résultats
figure;
subplot(2,1,1);
plot(lags, moyenne_es_biaise, 'b', 'LineWidth', 1.5); hold on;
plot(lags, moyenne_es_non_biaise, 'r', 'LineWidth', 1.5);
xlabel('Lag m'); ylabel('Autocorrélation moyenne');
legend('Biaisé', 'Non-biaisé'); grid on;
title('Moyenne des estimateurs d''autocorrélation');

subplot(2,1,2);
plot(lags, var_es_biaise, 'b', 'LineWidth', 1.5); hold on;
plot(lags, var_es_non_biaise, 'r', 'LineWidth', 1.5);
xlabel('Lag m'); ylabel('Variance de l''estimateur');
legend('Biaisé', 'Non-biaisé'); grid on;
title('Variance des estimateurs d''autocorrélation');

%%  Question 4

% % Paramètres
N = 50;  % Nombre d'échantillons par réalisation
M = 100; % Nombre de réalisations
lag_max = N-1; % Maximum des décalages considérés

% Initialisation des matrices pour stocker les autocorrélations estimées
au_biaise = zeros(2*N-1, M);
au_non_biaise = zeros(2*N-1, M);

% Génération des signaux et calcul des autocorrélations
for i = 1:M
    B = randn(1, N);    % Bruit blanc gaussien centré, variance unitaire
    X = B + 1;          % Signal X1[n]

    % Autocorrélation biaisée et non biaisée avec xcorr
    [bisaie, lags] = xcorr(X, 'biased');
    [non_biaise, ~] = xcorr(X, 'unbiased');

    % Stockage des résultats
    au_biaise(:, i) = bisaie;
    au_non_biaise(:, i) = non_biaise;
end
% 
% Moyenne et écart-type des estimateurs
moyenne_es_biaise = mean(au_biaise, 2);
moyenne_es_non_biaise = mean(au_non_biaise, 2);

R_biased_std = std(au_biaise, 0, 2);
R_unbiased_std = std(au_non_biaise, 0, 2);

% Tracé des résultats avec intervalles de confiance
figure;
subplot(2,1,1);
hold on;
plot(lags, moyenne_es_biaise, 'b', 'LineWidth', 1.5);
plot(lags, moyenne_es_biaise + R_biased_std, '--b');
plot(lags, moyenne_es_biaise - R_biased_std, '--b');
xlabel('Lag m'); ylabel('Autocorrélation');
legend('Biaisé', 'Biaisé + écart-type', 'Biaisé - écart-type'); grid on;
title('Estimateur biaisé de l''autocorrélation');

subplot(2,1,2);
hold on;
plot(lags, moyenne_es_non_biaise, 'r', 'LineWidth', 1.5);
plot(lags, moyenne_es_non_biaise + R_unbiased_std, '--r');
plot(lags, moyenne_es_non_biaise - R_unbiased_std, '--r');
xlabel('Lag m'); ylabel('Autocorrélation');
legend('Non-biaisé', 'Non-biaisé + écart-type', 'Non-biaisé - écart-type'); grid on;
title('Estimateur non-biaisé de l''autocorrélation');

%% Périodogramme

clear; clc; close all;

% Paramètres
N = 128;    % Nombre d'échantillons temporels
M1 = 100;   % Nombre de réalisations (premier test)
M2 = 1000;  % Nombre de réalisations (second test)
fs = 1;     % Fréquence d'échantillonnage

% Fonction pour calculer le périodogramme moyen et l'écart-type
periodogramme = @(M) deal(...
    mean(abs(fftshift(fft(randn(M, N), [], 2) / sqrt(N)).^2), 1), ...
    std(abs(fftshift(fft(randn(M, N), [], 2) / sqrt(N)).^2), 0, 1) ...
);

% Fréquences normalisées
f = linspace(-fs/2, fs/2, N);

% Calcul des périodogrammes
[moyenne_100, std_100] = periodogramme(M1);
[moyenne_1000, std_1000] = periodogramme(M2);

% Affichage des résultats
figure;
subplot(2,1,1);
hold on;
plot(f, moyenne_100, 'b', 'LineWidth', 1.5);
plot(f, moyenne_100 + std_100, '--b');
plot(f, moyenne_100 - std_100, '--b');
xlabel('Fréquence normalisée'); ylabel('Périodogramme');
legend('Moyenne', 'Moyenne + écart-type', 'Moyenne - écart-type');
grid on;
title('Périodogramme moyen avec M=100');

subplot(2,1,2);
hold on;
plot(f, moyenne_1000, 'r', 'LineWidth', 1.5);
plot(f, moyenne_1000 + std_1000, '--r');
plot(f, moyenne_1000 - std_1000, '--r');
xlabel('Fréquence normalisée'); ylabel('Périodogramme');
legend('Moyenne', 'Moyenne + écart-type', 'Moyenne - écart-type');
grid on;
title('Périodogramme moyen avec M=1000');

%%  périodogramme moyenné

N = 1024;
Fs = 1;             % 1 Hz ici
x1 = randn(1, N);    % Signal 1 : bruit blanc 
% Signal 2 : somme de deux sinusoïdes
f0 = 0.1; 
f1 = 0.15;
phi0 = 2 * pi * rand;
phi1 = 2 * pi * rand;
n = 0:N-1;
x2 = cos(2*pi*f0*n + phi0) + cos(2*pi*f1*n + phi1);

% --- Liste des valeurs de L à tester
L_list = [1, 16, 32, 128];

for sig_idx = 1:2
    if sig_idx == 1
        x = x1;
        sig_name = 'Bruit blanc';
    else
        x = x2;
        sig_name = 'Deux sinusoïdes';
    end

    figure;
    sgtitle(['Périodogramme moyenné - ', sig_name]);
    
    for i = 1:length(L_list)
        L = L_list(i);
        M = N / L;
        
        % Découpage en L sections
        sections = reshape(x, M, L);
        
        % Calcul périodogrammes
        S_p_avg = zeros(1, M);
        for l = 1:L
            Xf = fft(sections(:, l), M);
            S_p = (1/M) * abs(Xf).^2;
            S_p_avg = S_p_avg + S_p;
        end
        S_p_avg = S_p_avg / L;
        
        % Axe des fréquences
        f = (0:M-1) / M * Fs;
        
        % Sous-figure
        subplot(2,2,i);
        plot(f, 10*log10(S_p_avg)); % Affichage en dB pour mieux visualiser
        title(['L = ', num2str(L)]);
        xlabel('Fréquence normalisée');
        ylabel('DSP estimée [dB]');
        grid on;
    end
end

%%  Périodogramme de Welch 

% Paramètres
N = 1024;                        % Nombre total d'échantillons
fs = 1;                          % Fréquence d'échantillonnage
f0 = 0.1;                        % Fréquence de la sinusoïde
phi0 = 2 * pi * rand;            % Phase aléatoire
B = sqrt(4) * randn(1, N);       % Bruit blanc de variance 4

% Signal X[n] = cos(2πf0n + φ0) + B[n]
n = 0:N-1;
X = cos(2 * pi * f0 * n + phi0) + B;

% --- Calcul des périodogrammes ---
% 1. Périodogramme simple
[Px, f] = periodogram(X, [], [], fs);

% 2. Périodogramme de Welch
[Pw, fw] = pwelch(X, [], [], [], fs);

% --- Affichage ---
figure;

% Tracé du périodogramme simple
subplot(2,1,1);
plot(f, 10*log10(Px), 'b', 'LineWidth', 1.5);
title('Périodogramme simple');
xlabel('Fréquence normalisée'); ylabel('DSP (dB)');
grid on;

% Tracé du périodogramme de Welch
subplot(2,1,2);
plot(fw, 10*log10(Pw), 'r', 'LineWidth', 1.5);
title('Périodogramme de Welch');
xlabel('Fréquence normalisée'); ylabel('DSP (dB)');
grid on;
