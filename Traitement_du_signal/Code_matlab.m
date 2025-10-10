load('Multi.mat');           % Charger le fichier 
signal=importdata('Multi.mat');
Fe=132300;
N = length(signal);          % Taille du signal
f = (0:N-1)*(Fe/N);          % Axe des fréquences
Y = abs(fft(signal));        % la FFT      
% Tracer la représentation fréquentielle
figure;
plot(f, Y);
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Représentation fréquentielle');
xlim([0 Fe/2]); % Restreindre à la moitié de la bande 
                % pour une meilleure lisibilité
figure;
plot(f(1:N/2),20*log10(abs(Y(1:N/2))));
grid on;
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
title('Représentation en échelle logarithmique (logarithme en dB)');
xlim([0 Fe/2]); % Restreindre à la moitié de la bande 
                % pour une meilleure lisibilité
 



figure;
plot(f(1:N/2),20*log10(abs(Y(1:N/2))));
grid on;
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
%title('Représentation en échelle logarithmique (logarithme en dB)');
xlim([0 Fe/2]); % Restreindre à la moitié de la bande 
                % pour une meilleure lisibilité              
title('Réponse fréquentielle du filtre passe-bas');
% Annotations pour les bandes
hold on;
xline(16000, '--r', 'Fréquence de coupure','LabelOrientation','horizontal'); % Fréquence de coupure



figure;
plot(f(1:N/2),20*log10(abs(Y(1:N/2))));
grid on;
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
%title('Représentation en échelle logarithmique (logarithme en dB)');
xlim([0 Fe/2]); % Restreindre à la moitié de la bande 
                % pour une meilleure lisibilité              
title('Réponse fréquentielle du filtre passe bande ur f0');
% Annotations pour les bandes
hold on;
xline(22000, '--r', 'Fréquence de coupure','LabelHorizontalAlignment', 'left'); % Fréquence de coupure
hold on;
xline(54000,'--r','Fréquence de coupure','LabelHorizontalAlignment', 'right'); % Fréquence de coupure




figure;
plot(f(1:N/2),20*log10(abs(Y(1:N/2))));
grid on;
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
%title('Représentation en échelle logarithmique (logarithme en dB)');
xlim([0 Fe/2]); % Restreindre à la moitié de la bande 
                % pour une meilleure lisibilité              
title('Réponse fréquentielle du filtre passe bande ur f0/2');
% Annotations pour les bandes
hold on;
xline(14000, '--r', 'Fréquence de coupure','LabelHorizontalAlignment', 'left'); % Fréquence de coupure
hold on;
xline(24000,'--r','Fréquence de coupure','LabelHorizontalAlignment', 'right'); % Fréquence de coupure





figure;
plot(f(1:N/2),20*log10(abs(Y(1:N/2))));
grid on;
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
%title('Représentation en échelle logarithmique (logarithme en dB)');
xlim([0 Fe/2]); % Restreindre à la moitié de la bande 
                % pour une meilleure lisibilité              
title('Réponse fréquentielle du filtre passe bas de x2(t)');
% Annotations pour les bandes
hold on;
xline(22000, '--r', 'Fréquence de coupure','LabelHorizontalAlignment', 'left'); % Fréquence de coupure
hold on;
xline(40000,'--r','Fréquence de coupure','LabelHorizontalAlignment', 'right'); % Fréquence de coupure


***************************************************************************************************************

load('Multi.mat');           % Charger le fichier 
signal=importdata('Multi.mat');
fe = 132300;          % Fréquence d'échantillonnage
fc = 13000;           % Fréquence de coupure (Hz)
Wc = fc / (fe / 2);   % Fréquence de coupure normalisée
n = 100;              % Ordre initial du filtre (ajustez par essais)
h = fir1(n, Wc, 'low', hamming(n+1)); % Filtre passe-bas
[H, freq] = freqz(h, 1, 1024, fe);
amplitude_dB = 20 * log10(abs(H));
% plot(freq, amplitude_dB);
% xlabel('Fréquence (Hz)');
% ylabel('Amplitude (dB)');
% title('Réponse fréquentielle du filtre passe-bas');
% delay = n / (2 * fe);
% fprintf('Le retard du filtre est %.6f secondes.\n', delay);
% x1 = filter(h, 1, signal); % Remplacez 'y' par votre signal réel
% t = (0:length(x1)-1) / fe;
% plot(t, x1);
% xlabel('Temps (s)');
% ylabel('Amplitude');
% title('Signal x_1(t) dans le domaine temporel');
N = length(x1);
X1 = fft(x1);
f = (0:N-1) * (fe / N);
plot(f(1:N/2), abs(X1(1:N/2)));
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre de x_1(t)');
sound(x1,fe)



*****************************************************************************************************