clear; 
close all; 
clc;

%%  II. Génération d'un mélange artificiel de deux sources

% Q1

load('s.mat');   % doit contenir s1 et s2

figure;
plot(s1); grid on; title('s1(t)');
figure;
plot(s2); grid on; title('s2(t)');

%% Q2

R = corrcoef(s1, s2);
rho = R(1,2);        % coefficient de corrélation

disp(rho);

%% Q3

% matrice de mélange
A = [1   0.7;
     0.8 1];

% mélange
x1 = A(1,1)*s1 + A(1,2)*s2;
x2 = A(2,1)*s1 + A(2,2)*s2;

% juste pour voire les mélanges
figure;
plot(x1); grid on; title('x1(t)');
figure;
plot(x2); grid on; title('x2(t)');


%%  III. Méthode LI-TEMPROM

% Q5

M = 1000;  
%M = 200 ; 
%M = 50;
N = length(x1);
K = floor(N/M);
% on garde juste la partie divisible par M
x1c = x1(1:K*M);
x2c = x2(1:K*M);
% chaque colonne = une zone de M points
X1 = reshape(x1c, M, K);
X2 = reshape(x2c, M, K);
% rapport dans chaque zone (matrice MxK)
R = X2 ./ X1;
% variance colonne par colonne => 1xK puis on met en colonne Kx1
var_ratio = var(R, 0, 1)';
display(var_ratio)

% juste pour afficher
figure;
stem(var_ratio, 'filled'); grid on;
xlabel('numéro de la zone');
ylabel('Var de x2/x1');
title('variance du rapport x2/x1 par zone');

%% Q7

seuil = 1e-3;     

var_ratio = zeros(K,1);
mono = zeros(K,1);          % 1 si zone mono-source
r_mean = NaN(K,1);          % moyenne du rapport dans la zone
Ahat_cols = [];             % liste des colonnes estimées [1; mean(r)]

for k = 1:K
    ind = (k-1)*M + (1:M);
    % rapport dans la zone
    r = x2(ind) ./ x1(ind);
    % variance du rapport
    var_ratio(k) = var(r);
    % décision mono-source
    if var_ratio(k) < seuil
        mono(k) = 1;
        % moyenne du rapport (valeur "constante" estimée)
        r_mean(k) = mean(r);
        % colonne estimée
        Ahat_cols = [Ahat_cols, [1; r_mean(k)]];
    end
end

% affichage globale  simple 
disp("variances par zone :"); disp(var_ratio');
disp("zones mono-source (1 oui / 0 non) :"); disp(mono');
disp("mmoyenne de rapport dans zones mono :"); disp(r_mean');
% Colonnes estimées (une par zone mono détectée)
disp("Colonnes estimées (un par zone mono) :");
disp(Ahat_cols);

%% Q8

figure;
plot(Ahat_cols(1,:), Ahat_cols(2,:), 'o');
grid on;
xlabel('composante 1'); ylabel('composante 2');
title('Colonnes estimées dans chaque zone mono-source');

% On regroupe les colonnes estimées en 2 clusters
% (chaque cluster correspond à une colonne de A)
idx = kmeans(Ahat_cols', 2);   % Ahat_cols' : points (nb_points x 2)

% Moyenne des colonnes dans chaque cluster => estimation finale
A1 = mean(Ahat_cols(:, idx==1), 2);
A2 = mean(Ahat_cols(:, idx==2), 2);

% Matrice A estimée (colonnes)
A_est = [A1, A2];

disp("A_est = ");
disp(A_est);

% juste pour vérifier visuellement

figure;
plot(Ahat_cols(1,:), Ahat_cols(2,:), 'o'); hold on;
plot(A1(1), A1(2), 'x', 'MarkerSize', 12, 'LineWidth', 2);
plot(A2(1), A2(2), 'x', 'MarkerSize', 12, 'LineWidth', 2);
grid on;
xlabel('a(1)'); ylabel('a(2)');
title('colonnes estimées + moyennes (2 colonnes finales)');
legend('colonnes par zones', 'colonne finale 1', 'colonne finale 2');

%% Q9

% x1,x2 vecteurs colonnes
x1 = x1(:);
x2 = x2(:);

% s'assurer qu'ils ont la même longueur
N = min(length(x1), length(x2));
x1 = x1(1:N);
x2 = x2(1:N);

% construire X en 2xN
X = [x1.'; x2.'];      % 2 x N  (note: .' = transpose sans conjugaison)
% séparation sans inv
Y = A_est \ X;         % 2 x N
y1 = Y(1,:).';
y2 = Y(2,:).';
% puissance unitaire
y1 = y1 / sqrt(mean(y1.^2));
y2 = y2 / sqrt(mean(y2.^2));

% s'assurer que s1, s2 sont des vecteurs colonnes
s1 = s1(:); s2 = s2(:);

figure;

subplot(4,1,1);
plot(s1); grid on;
title('Source originale s1(t)'); ylabel('amp');
subplot(4,1,2);
plot(s2); grid on;
title('Source originale s2(t)'); ylabel('amp');
subplot(4,1,3);
plot(y1); grid on;
title('Source estimée y1(t)'); ylabel('amp');
subplot(4,1,4);
plot(y2); grid on;
title('Source estimée y2(t)');
xlabel('temps'); ylabel('amp');


%% Q11  (Audio) 

clear; close all; clc;

%  Lire les deux mélanges audio
[x1, Fs] = audioread('audio_mix1_tp3.wav');
[x2, ~ ] = audioread('audio_mix2_tp3.wav');

% Écoute des mélanges
soundsc(x1, Fs); pause(length(x1)/Fs + 1);
soundsc(x2, Fs); pause(length(x2)/Fs + 1);

% Paramètres
M = 1000;     
seuil = 1e-2;    
epsx  = 1e-3;    

%  s'assurer mm longueur et découpage en zones
N = min(length(x1), length(x2));
x1 = x1(1:N);
x2 = x2(1:N);

K  = floor(N/M);
x1 = x1(1:K*M);
x2 = x2(1:K*M);

% détection zones mono-sources + estimation de colonnes (Q5-Q7)
var_ratio = NaN(K,1);
mono      = zeros(K,1);
r_mean    = NaN(K,1);
Ahat_cols = [];

for k = 1:K
    ind = (k-1)*M + (1:M);

    % ratio dans la zone, en évitant les x1 trop petits
    mask = abs(x1(ind)) > epsx;
    r = x2(ind(mask)) ./ x1(ind(mask));

    % pas assez de points valides -> on saute
    if numel(r) < 50
        continue;
    end

    var_ratio(k) = var(r);

    if var_ratio(k) < seuil
        mono(k)   = 1;
        r_mean(k) = mean(r);
        Ahat_cols = [Ahat_cols, [1; r_mean(k)]];
    end
end

disp("Nb zones mono détectées = " + sum(mono));
disp("Ahat_cols size = "); disp(size(Ahat_cols));

figure;
stem(var_ratio, 'filled'); grid on;
xlabel('Zone k'); ylabel('Var(x2/x1)');
title('Variance du rapport x2/x1 par zone (audio)');

% Q8 : estimation finale de A
if size(Ahat_cols,2) < 2
    error("Pas assez de zones mono-sources détectées. Essayez M plus grand (2000/5000) ou seuil plus grand (1e-1).");
end

% si on a exactement 2 estimations -> pas besoin de kmeans
if size(Ahat_cols,2) == 2
    A_est = Ahat_cols;
else
    idx = kmeans(Ahat_cols', 2);     % points (nb_points x 2)
    A1  = mean(Ahat_cols(:, idx==1), 2);
    A2  = mean(Ahat_cols(:, idx==2), 2);
    A_est = [A1, A2];
end

disp("A_est = "); disp(A_est);

figure;
plot(Ahat_cols(1,:), Ahat_cols(2,:), 'o'); hold on; grid on;
plot(A_est(1,1), A_est(2,1), 'x', 'MarkerSize', 12, 'LineWidth', 2);
plot(A_est(1,2), A_est(2,2), 'x', 'MarkerSize', 12, 'LineWidth', 2);
xlabel('a(1)'); ylabel('a(2)');
title('Colonnes estimées (audio) + 2 colonnes finales');
legend('colonnes par zones', 'colonne finale 1', 'colonne finale 2');

% Q9 : Séparation Y = A^-1 * X
X = [x1.'; x2.'];     % 2 x (K*M)
Y = A_est \ X;        % 2 x (K*M)

y1 = Y(1,:).';
y2 = Y(2,:).';

% normalisation puissance unitaire
y1 = y1 / sqrt(mean(y1.^2));
y2 = y2 / sqrt(mean(y2.^2));

% Écoute des sources estimées
soundsc(y1, Fs); pause(length(y1)/Fs + 1);
soundsc(y2, Fs); pause(length(y2)/Fs + 1);

% Affichage simple
figure; plot(y1); grid on; title('Source estimée y1(t) (audio)');
figure; plot(y2); grid on; title('Source estimée y2(t) (audio)');


%% Q14  LI-TEMPCORR

clear; close all; clc;

% Charge audio
[x1, Fs] = audioread('audio_mix1_tp3.wav');
[x2, ~ ] = audioread('audio_mix2_tp3.wav');

if size(x1,2) > 1, x1 = mean(x1,2); end
if size(x2,2) > 1, x2 = mean(x2,2); end

x1 = x1(:); x2 = x2(:);

% écouter mélange
soundsc(x1, Fs); pause(length(x1)/Fs + 1);
soundsc(x2, Fs); pause(length(x2)/Fs + 1);

% paramètres 
M = 1000;
rho_seuil = 0.95;   

% découper en zones
N = min(length(x1), length(x2));
x1 = x1(1:N); x2 = x2(1:N);

K = floor(N/M);
x1 = x1(1:K*M);
x2 = x2(1:K*M);

% détecter zones mono-source + estimer C ---
C_list = [];    % on stock les C trouvés

for k = 1:K
    ind = (k-1)*M + (1:M);

    x1z = x1(ind);
    x2z = x2(ind);

    R = corrcoef(x1z, x2z);
    rho = R(1,2);

    if abs(rho) > rho_seuil
        C = mean(x1z .* x2z) / mean(x1z.^2);  % Q13
        C_list = [C_list; C];
    end
end

disp("Nb zones mono détectées = " + length(C_list));
disp("Valeurs C trouvées :"); disp(C_list.');

idx = kmeans(C_list, 2);

C1 = mean(C_list(idx==1));
C2 = mean(C_list(idx==2));

A_est = [1 1; C1 C2];      
disp("A_est = "); disp(A_est);

% Séparation
X = [x1.'; x2.'];      % 2 x N
Y = A_est \ X;         % 2 x N

y1 = Y(1,:).';  y2 = Y(2,:).';

% normaliser puissance unitaire
y1 = y1 / sqrt(mean(y1.^2));
y2 = y2 / sqrt(mean(y2.^2));

% écouter sources estimées
soundsc(y1, Fs); pause(length(y1)/Fs + 1);
soundsc(y2, Fs);