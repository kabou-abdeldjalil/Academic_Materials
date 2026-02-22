clear; 
close all; 
clc;

%% I. Débruitage avec référence de bruit

% Q2
[d, Fs] = audioread('noisy_sig.wav');   
[x, ~ ] = audioread('noise_ref.wav'); 

d = d(:,1);  
x = x(:,1);

soundsc(d, Fs); pause(3); soundsc(x, Fs); 
%% Q3

% corrélations
Rdx = xcorr(d, x, 'biased',100);   % anti
Rxx = xcorr(x, x, 'biased',100);   % auto

% filtre en fréquence
W = fft(Rdx) ./ (fft(Rxx) + eps);

% réponse impulsionnelle
w = real(ifft(W));

% estimation du bruit
n_hat = filter(w,1,x);

% estimation du signal utile
s_hat = d - n_hat;

% écoute
soundsc(s_hat, Fs);

%% II. Débruitage par soustraction spectrale

% Q2
[x, Fs] = audioread('noisy_sig_fan.wav');
x = x(:,1); 
soundsc(x, Fs);

%% Q3

% Paramètres
w   = round(0.025 * Fs);   % nb d'échantillons (w = 0,025 × 48000 = 1200)
fen = hamming(w);          % fenêtre de Hamming
dec = 0.4;                 % décalage 40 %

% découpage en tranches
X = decoupage(x, fen, w, dec);

size(X)

%% Q4

% FFT des tranches
F = fft(X);
A = abs(F);          % amplitude
P = angle(F);        % phase

% nb de tranches "bruit seul" (0.5 s au début)
Nb = floor((0.5*Fs - w) / (dec*w)) + 1;
Nb = max(1, min(Nb, size(X,2)));   % juste pour sécurité

% spectre moyen du bruit
B = mean(A(:,1:Nb), 2);

% soustraction spectrale
A2 = A - B;
A2(A2 < 0) = 0;

% retour au temps (on garde la phase)
S = A2 .* exp(1j*P);
T = real(ifft(S));

% reconstruction + écoute
x_hat = reconstruction(T, w, dec);
x_hat = x_hat / max(abs(x_hat)+eps);
soundsc(x_hat, Fs);

%% Q5

% Spectre du bruit résiduel dans les zones de silence
NR = A2(:, 1:Nb);     % uniquement les tranches de silence

% Maximum du bruit résiduel pour chaque fréquence
max_NR = max(NR, [], 2);

%% Q6

A6 = A2;                      % copie
K = size(A2,2);               % nb de tranches

for i = 1:K
    i1 = max(i-1, 1);         % tranche i-1 (bornée)
    i2 = i;
    i3 = min(i+1, K);         % tranche i+1 (bornée)

    m3 = min(A2(:, [i1 i2 i3]), [], 2);   % minimum sur 3 tranches, freq par freq
    mask = (A2(:, i) < max_NR);           % notre condition de l'énoncé

    A6(mask, i) = m3(mask);               % remplacement
end

%% Q7

% on test en dB et remplacement à 3 %
A7 = A6;                      % copie
K = size(A6,2);               % nb de tranches
Bmean_amp = mean(B);          % moyenne du bruit 

for i = 1:K
    ratio_dB = 20*log10( mean(A6(:,i)) / (Bmean_amp + eps) );

    if ratio_dB < -12
        A7(:,i) = 0.03 * A(:,i);   % 3 % du spectre observé
    end
end

%% Q8

% reconstituer le spectre (module + phase)
Sf_final = A7 .* exp(1j * P);

% retour au domaine temporel (par tranche)
T_final = real(ifft(Sf_final));

% reconstruction du signal complet
x_final = reconstruction(T_final, w, dec);

soundsc(x_final, Fs);

