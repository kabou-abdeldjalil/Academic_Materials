%%  Analyse

% Chargement du signal et l'écoute
[x0, Fe] = audioread('sig.wav');
x = x0(:,1);  % Mono
sound(x0, Fe);

%  la représentation temporelle (audiogramme)
N = length(x); % Nombre d'échantillons
t = (0:N-1) / Fe; % Axe temporel
figure;
plot(t, x);
xlabel('Temps (s)'); ylabel('Amplitude');
title('Audiogramme du signal de parole');
grid on;

%%
% Suppression des silences par seuil d'énergie
threshold = 0.02;
energy = abs(x);
start_index = find(energy > threshold, 1, 'first');
end_index = find(energy > threshold, 1, 'last');

x_coup = x(start_index:end_index);
t_coup = (0:length(x_coup)-1)/Fe;

% Affichage du signal coupé
figure;
plot(t_coup, x_coup);
xlabel('Temps (s)'); ylabel('Amplitude');
title('Signal x coupé sans silences');
sound(x_coup, Fe);

%%
% FFT du signal
figure;
N = length(x_coup);
X = abs(fft(x_coup));
f = linspace(0, Fe, N);
plot(f, X);
xlim([0 Fe]);
xlabel('Fréquence (Hz)');
ylabel('|X(f)|');
title('Module de la FFT de x');

%%
% Spectrogramme à bande étroite
figure;
spectrogram(x_coup, 0.05*Fe, 0.025*Fe, 0.05*Fe, Fe, 'yaxis');
title('Spectrogramme à bande étroite');

%%
% Spectrogramme à bande large
figure;
spectrogram(x_coup, 0.01*Fe, 0.005*Fe, 0.01*Fe, Fe, 'yaxis');
title('Spectrogramme à bande large');

%%

% --- Codage LPC ---

%%
% Paramètres de tranchage
x = x_coup;  % On travaille à partir du signal sans silence
duree_tranche = 0.030;                   % 30 ms
taille_tranche = round(duree_tranche * Fe);
nb_tranches = floor(length(x) / taille_tranche);

% Calcul puissance moyenne
puissances = zeros(1, nb_tranches);
for i = 1:nb_tranches
    debut = (i-1)*taille_tranche + 1;
    fin = i*taille_tranche;
    tranche = x(debut:fin);
    puissances(i) = mean(tranche.^2);
end
disp('Puissance moyenne des tranches :');
disp(puissances);
figure;
plot(puissances);

%%
% Estimation du pitch
min_pitch = round(Fe / 600);
max_pitch = round(Fe / 70);
pitch_vecteur = zeros(1, nb_tranches);

%puissances < 0.005 ;
non_voisees = puissances < 0.005 ;  % Tranches considérées non voisées

for i = 1:nb_tranches
    debut = (i-1)*taille_tranche + 1;
    fin = i*taille_tranche;
    tranche = x(debut:fin);
    
    if non_voisees(i)
        pitch_vecteur(i) = 0;
    else
        [r, ~] = xcorr(tranche, 'biased');
        r_pos = r(length(tranche):end);
        [~, idx] = max(r_pos(min_pitch:max_pitch));
        pitch_vecteur(i) = (min_pitch + idx - 1) / Fe;
    end
end
disp('Vecteur des périodes pitch (en secondes) :');
disp(pitch_vecteur);
figure;
plot(pitch_vecteur);

%%

P = 12; % Ordre du modèle LPC
nb_tranches = floor(length(x) / taille_tranche); % Nombre total de tranches
lpc_matrix = zeros(nb_tranches, P); % Matrice pour stocker les coefficients

for i = 1:nb_tranches
    debut = (i-1) * taille_tranche + 1;
    fin = i * taille_tranche;
    tranche = x(debut:fin);

    % Calcul de l'autocorrélation du signal de parole
    R = xcorr(tranche, P, 'biased'); % Autocorrélation centrée
    R = R(P+1:end); % On prend R(0) à R(P)

    % Construction de la matrice de Toeplitz
    Gamma = toeplitz(R(1:P));  
    c = -R(2:P+1); % Second membre du système

    % Résolution de Gamma * a = c
    a = Gamma \ c;

    % Stocker les coefficients sans a(0) = 1
    lpc_matrix(i, :) = a';
end

disp('Matrice des coefficients LPC :');
disp(lpc_matrix);


%%
% Initialisation du signal synthétisé

%  Synthétise du signal et écoute le résultat
x_synthe = [];

for i = 1:nb_tranches
    % Si la tranche est non voisée
    if ismember(i, non_voisees)
        source = randn(taille_tranche, 1);  % Bruit blanc pour non voisée
    else
        period = round(pitch_vecteur(i) * Fe);  % Période de pitch
        impulse_train = zeros(taille_tranche, 1);
        impulse_train(1:period:end) = 1;  % Train d'impulsions pour voisée
        source = impulse_train;
    end
    
    % Appliquer le modèle AR avec les coefficients LPC
    lpc_coeffs = [1 lpc_matrix(i, :)];
    x_synthe = [x_synthe; filter(1, lpc_coeffs, source)];  % Filtrage
end

% Normalisation du signal synthétisé
x_synthe = x_synthe / max(abs(x_synthe));  

% Écouter le signal synthétisé
soundsc(x_synthe, Fe);


%%
%   Recommencer la synthèse en multipliant la période pitch de toutes les tranches par 2
x_synthe = [];

for i = 1:nb_tranches
    % Si la tranche est non voisée
    if ismember(i, non_voisees)
        source = randn(taille_tranche, 1);  % Bruit blanc pour non voisée
    else
        period = round(2 * pitch_vecteur(i) * Fe);  % Période de pitch
        impulse_train = zeros(taille_tranche, 1);
        impulse_train(1:period:end) = 1;  % Train d'impulsions pour voisée
        source = impulse_train;
    end
    
    % Appliquer le modèle AR avec les coefficients LPC
    lpc_coeffs = [1 lpc_matrix(i, :)];
    x_synthe = [x_synthe; filter(1, lpc_coeffs, source)];  % Filtrage
end

% Normalisation du signal synthétisé
x_synthe = x_synthe / max(abs(x_synthe));  

% Écouter le signal synthétisé
soundsc(x_synthe, Fe);

%%

%   Recommencer en fixant une période pitch constante pour toutes les tranches voisées
x_synthe = [];

for i = 1:nb_tranches
    % Si la tranche est non voisée
    if ismember(i, non_voisees)
        source = randn(taille_tranche, 1);  % Bruit blanc pour non voisée
    else
        fixed_pitch = 0.01;  % Exemple : période fixée à 10 ms
        period = round(fixed_pitch * Fe);
        impulse_train = zeros(taille_tranche, 1);
        impulse_train(1:period:end) = 1;  % Train d'impulsions pour voisée
        source = impulse_train;
    end
    
    % Appliquer le modèle AR avec les coefficients LPC
    lpc_coeffs = [1 lpc_matrix(i, :)];
    x_synthe = [x_synthe; filter(1, lpc_coeffs, source)];  % Filtrage
end

% Normalisation du signal synthétisé
x_synthe = x_synthe / max(abs(x_synthe));  

% Écouter le signal synthétisé
soundsc(x_synthe, Fe);

%%

% Définition de l'ordre du modèle
P = 12;

% Sélection de deux tranches non-voisées
tranche1 = non_voisees(1);
tranche2 = non_voisees(2);

% Extraction des coefficients LPC
a1 = [1, lpc_matrix(tranche1, :)]; 
a2 = [1, lpc_matrix(tranche2, :)];

% Calcul de la réponse fréquentielle
[H1, w] = freqz(1, a1, 1024, Fe);
[H2, ~] = freqz(1, a2, 1024, Fe);

% Tracé de la racine carrée de la DSP
figure;
plot(w, abs(H1), 'b', 'LineWidth', 1.5); hold on;
plot(w, abs(H2), 'r', 'LineWidth', 1.5);
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
legend('Tranche 1', 'Tranche 2');
title('Racine carrée de la DSP des phonèmes non-voisés');
grid on;

%%
