****************************************************************************************   (3
[signal, Fe, nbits] = audioread('signal0.wav'); 
% Afficher les informations
disp(['Fréquence d’échantillonnage : ', num2str(Fe), ' Hz']);
disp(['Nombre de bits : ', num2str(nbits), ' bits']);
% Écouter le signal (on peut utiliser "sound(signal, Fe)" );
% Lecture normale du signal
disp('Lecture du signal original :');
PlaySignal(signal, Fs);
% Lecture avec sous-échantillonnage (par exemple, S = 2)
S = 2; % Facteur de sous-échantillonnage
disp(['Lecture du signal sous-échantillonné avec S = ', num2str(S), ':']);
PlaySignal(signal, Fs, S);

Soit :

% Charger le signal audio avec wavread (ancienne méthode) ou audioread (nouvelle méthode)
[signal, Fe] = wavread('signal0.wav'); % signal : données audio, Fe : fréquence d'échantillonnage
% Lire les métadonnées du fichier pour le nombre de bits
info = audioinfo('signal0.wav'); % Cette ligne fonctionne uniquement avec audioread
% Afficher les informations du fichier audio
disp(['Fréquence d’échantillonnage : ', num2str(Fe), ' Hz']);
disp(['Nombre de bits : ', num2str(info.BitsPerSample), ' bits']);
% Écouter le signal
PlaySignal(signal, Fe); % Fonction fournie pour écouter le signal

Soit :

% Charger le signal et ses informations de base
[signal, Fe, nbits] = wavread('signal0.wav'); 
% signal : données audio, Fe : fréquence d'échantillonnage, nbits : nombre de bits
% Afficher les informations extraites
disp(['Fréquence d’échantillonnage : ', num2str(Fe), ' Hz']);
disp(['Nombre de bits : ', num2str(nbits), ' bits']);
% Écouter le signal
PlaySignal(signal, Fe); % Lecture avec la fonction fournie
*******************************************************************************************************  (4
% Charger le signal
[signal, Fe] = wavread('signal0.wav'); % signal : données audio, Fe : fréquence d'échantillonnage
% Facteurs de sous-échantillonnage
S = 1;
%S = 2;
%S = 4;
%S = 8;
%S = 16;
disp(['Lecture du signal sous-échantillonné avec S = ', num2str(S)]);
PlaySignal(signal, Fe, S); % Lecture sous-échantillonnée


Soit:


% Charger le signal
[signal, Fe, ~] = wavread('signal0.wav'); % signal : données audio, Fe : fréquence d'échantillonnage

% Facteurs de sous-échantillonnage
S_values = [1, 2, 4, 8, 16]; % Essayez différents facteurs de sous-échantillonnage

% Boucle pour écouter et observer
for S = S_values
    disp(['Lecture du signal sous-échantillonné avec S = ', num2str(S)]);
    PlaySignal(signal, Fe, S); % Lecture sous-échantillonnée
    pause(3); % Pause pour écouter le signal avant de passer au suivant
end

********************************************************************************************************  (5

% Charger le signal audio
[signal, Fe] = wavread('signal0.wav'); % signal : données audio, Fe : fréquence d'échantillonnage

% Calculer la transformée de Fourier discrète avec tfsc2
[Xhat, f] = tfsc2(signal, Fe);

% Tracer la représentation fréquentielle
figure;
plot(f, abs(Xhat)); % Amplitudes en fonction des fréquences
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Représentation fréquentielle du signal');

% Identifier la fréquence maximale significative (où l'amplitude est significative)
threshold = max(abs(Xhat)) * 0.01; % Définir un seuil de 1% du maximum
f_max = max(f(abs(Xhat) > threshold)); % Trouver la fréquence maximale significative
disp(['Fréquence maximale dans le signal : ', num2str(f_max), ' Hz']);

% Appliquer le théorème de Shannon
Fe_min = 2 * f_max; % Fréquence minimale d’échantillonnage
disp(['Fréquence minimale d’échantillonnage selon Shannon : ', num2str(Fe_min), ' Hz']);

% Vérification de cohérence
if Fe >= Fe_min
    disp('La fréquence d’échantillonnage initiale est suffisante pour éviter les pertes.');
else
    disp('La fréquence d’échantillonnage initiale est insuffisante.');
end



Soit :


% Charger le signal audio
[signal, Fe] = wavread('signal0.wav'); % signal : données audio, Fe : fréquence d'échantillonnage

% Calculer et tracer la représentation fréquentielle avec tfsc2
[freq, amplitude] = tfsc2(signal, Fe); % Supposons que tfsc2 retourne les fréquences et amplitudes
figure;
plot(freq, amplitude);
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Représentation fréquentielle du signal');

% Identifier la fréquence maximale
f_max = max(freq(amplitude > threshold)); % threshold pour ignorer les très petites amplitudes
disp(['Fréquence maximale dans le signal : ', num2str(f_max), ' Hz']);

% Appliquer le théorème de Shannon
Fe_min = 2 * f_max; % Fréquence minimale d’échantillonnage selon Shannon
disp(['Fréquence minimale d’échantillonnage selon Shannon : ', num2str(Fe_min), ' Hz']);

% Vérification de cohérence
if Fe >= Fe_min
    disp('La fréquence d’échantillonnage initiale est suffisante pour éviter les pertes.');
else
    disp('La fréquence d’échantillonnage initiale est insuffisante.');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

************************************************************************************************(1
% Charger les données
load SignalReconst.mat; % Chargement des variables x (signal) et t (temps)
% Représentation temporelle
figure;
plot(t, x);
xlabel('Temps (s)'); ylabel('Amplitude');
title('Représentation temporelle du signal');
% Représentation fréquentielle
% Calculer la transformée de Fourier discrète avec tfsc2
Fe = 1;
[Xhat, f] = tfsc2(x, Fe);  % tfsc2 retourne les fréquences et amplitudes
figure;
plot(f, abs(Xhat));
xlabel('Fréquences normalisées (Hz)'); % (F_e = 1) 
ylabel('Amplitude');
title('Représentation fréquentielle du signal');


Soit :


% Charger les données
load SignalReconst.mat; % Chargement des variables x (signal) et t (temps)
% Représentation temporelle
figure;
plot(t, x);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Représentation temporelle du signal');
% Représentation fréquentielle
N = length(x); % Nombre d'échantillons
X = fft(x); % Transformée de Fourier du signal
f = linspace(0, 1, N); % Fréquences normalisées (F_e = 1)
amplitude = abs(X) / N; % Amplitude normalisée
figure;
plot(f, amplitude);
xlabel('Fréquence normalisée');
ylabel('Amplitude');
title('Représentation fréquentielle du signal');

***************************************************************************************************(2

% Charger les données
load SignalReconst.mat; % Chargement des variables x (signal) et t (temps)
% Calculer la transformée de Fourier discrète avec tfsc2
Fe = 1;
[Xhat, f] = tfsc2(x, Fe);  % tfsc2 retourne les fréquences et amplitudes
% Définir les valeurs de S à tester
S_values = [2, 4, 8]; % Facteurs de sous-échantillonnage
% Boucle sur différentes valeurs de S
for S = S_values
    % Sous-échantillonnage : ne garder qu'un échantillon sur S
    x_Sous_echantillon = zeros(size(x));
    x_Sous_echantillon(1:S:end) = x(1:S:end); % Échantillons à zéro sauf 1/S
    [Xhat_sous, f_sous] = tfsc2(x_Sous_echantillon, Fe);  % tfsc2 retourne les fréquences et amplitudes
    % Représentation temporelle
    figure;
    sabplot(2,2,1);
    plot(t, x, 'b');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title('Signal original');
    sabplot(2,2,3);
    plot(t, x_Sous_echantillon, 'r--');
    xlabel('Temps (s)');
    ylabel('Amplitude');
    title(['Signal sous-échantillonné (S = ', num2str(S), ')']);
    % Représentation fréquentielle    
    sabplot(2,2,2);
    plot(f, abs(Xhat),'b');
    xlabel('Fréquences normalisées (Hz)');
    ylabel('Amplitude');
    title('Représentation fréquentielle');
    sabplot(2,2,4);
    plot(f_sous,abs(Xhat_sous),'r--');
    xlabel('Fréquences normalisées (Hz)');
    ylabel('Amplitude');
    title(['Représentation fréquentielle (S = ', num2str(S), ')']);
end

