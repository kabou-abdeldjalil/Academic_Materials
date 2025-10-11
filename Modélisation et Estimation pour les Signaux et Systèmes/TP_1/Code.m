%% TP Moindres Carrés - Identification d'un Canal de Transmission

%KABOU Abdeldjalil (SIA2)

%%
clear; clc; close all;

%II_ modélisation de probléme:

N = 200;                        % Nombre d'échantillons
M = 33;                         % Longueur de la réponse impulsionnelle estimée

% Création du signal d'entrée
x = zeros(N,1);
x(1) = 1;       % Impulsion à n=0

% Chargement de la réponse impulsionnelle théorique
load('dataMC_2025.mat');  % Contient h et y (sortie)

sigma2 = 0.3;             % Variance du bruit
y = syst(x, h, sigma2);   % Simulation de la sortie bruitée du système
theta_RI = y(1:M);        % Estimation de la réponse impulsionnelle à partir de la sortie
disp('Réponse impulsionnelle estimée theta_RI :'); disp(theta_RI);

% Tracé de la réponse impulsionnelle réelle et estimée

figure;
plot(h, 'b', 'LineWidth', 1.5); hold on;
plot(theta_RI, 'r--', 'LineWidth', 1.5);
legend('Réponse impulsionnelle réelle', 'Réponse impulsionnelle estimée');
xlabel('Indice k'); ylabel('Amplitude');
title('Comparaison entre la réponse impulsionnelle réelle et estimée');
grid on;

%% III. Estimation de la Réponse Impulsionnelle par Entrée Impulsionnelle

x_impuls= [1; zeros(length(x)-1,1)];   % On applique une impulsion de Dirac à l'entrée 
y_impuls= syst(x_impuls, h, sigma2);   % Calcul de la sortie bruitée avec la fonction syst fournie
theta_RI = y_impuls(1:M);              % Estimation directe de la réponse impulsionnelle

% Affichage de la réponse impulsionnelle estimée
figure;
plot(theta_RI);
title('Estimation de la réponse impulsionnelle par entrée impulsionnelle');
xlabel('n'); ylabel('Amplitude');

% Calcul de l'erreur entre la réponse réelle et estimée
erreur = norm(h(1:M) - theta_RI);

% Affichage de l'erreur
disp('Norme de l''erreur ||θ - θ_RI|| :');
disp(erreur);

%%

Nmb_realisation = 200;  % Nombre de réalisations
H_RI = zeros(M, Nmb_realisation);  % Matrice pour stocker les réalisations

for i = 1:Nmb_realisation
    y_bruite = y + sqrt(sigma2) * randn(size(y));  % Ajout de bruit gaussien sur la sortie
    H_RI(:, i) = y_bruite(1:M);  % Estimation de la réponse impulsionnelle pour cette réalisation
end

% Calcul de la moyenne empirique et de la variance empirique
moyenne_h = mean(H_RI, 2);
variance_h = var(H_RI, 0, 2);

% Affichage des résultats
disp('Moyenne empirique des réalisations de h :'); disp(moyenne_h);
disp('Variance empirique des réalisations de h :'); disp(variance_h);

figure;
plot(h, 'b', 'LineWidth', 1.5); hold on;
plot(moyenne_h, 'r--', 'LineWidth', 1.5);
legend('Réponse impulsionnelle réelle', 'Moyenne empirique');
xlabel('Indice k'); ylabel('Amplitude');
title('Comparaison entre la vraie réponse et la moyenne empirique');
grid on;

R = toeplitz(x, [x(1); zeros(M-1,1)]);

% Calcul de la variance théorique
variance_h_theorique = sigma2 * diag(inv(R' * R));

% Tracé des variances
figure;
plot(variance_h, 'g', 'LineWidth', 1.5); hold on;
plot(variance_h_theorique, 'r--', 'LineWidth', 1.5);
legend('Variance empirique', 'Variance théorique');
xlabel('Indice k');
ylabel('Variance');
title('Comparaison de la variance empirique et théorique');
grid on;

%%  IV_ estimation par moindres carrés

% Construction de la matrice de régression Toeplitz
R = toeplitz(x, [x(1); zeros(M-1,1)]);

theta_MC = (R' * R) \ (R' * y);  % Estimation des paramètres par la méthode des moindres carrés

% Affichage des coefficients estimés
disp('Paramètres estimés par Moindres Carrés (theta_MC) :'); disp(theta_MC);

% Tracé de la réponse impulsionnelle réelle et estimée
figure;
plot(h, 'b', 'LineWidth', 1.5); hold on;
plot(theta_MC, 'r--', 'LineWidth', 1.5);
legend('Réponse impulsionnelle réelle', 'Réponse impulsionnelle estimée MC');
xlabel('Indice k'); ylabel('Amplitude');
title('Comparaison entre la réponse réelle et estimée par Moindres Carrés');
grid on;

% Calcul de la norme de l'erreur
erreur_MC = norm(h(1:M) - theta_MC);

% Affichage de l'erreur
disp('Norme de l''erreur entre h[k] et theta_MC :');
disp(erreur_MC);

theta_MC_real = zeros(M, Nmb_realisation); % Matrice pour stocker les réalisations

for i = 1:Nmb_realisation
    y_bruite = y + sqrt(0.8) * randn(size(y));   % Ajout d'un bruit gaussien sur la sortie
    theta_MC_real(:, i) = (R' * R) \ (R' * y_bruite);  % Estimation de la réponse impulsionnelle pour cette réalisation
end

% Calcul de la moyenne empirique
moyenne_MC = mean(theta_MC_real, 2);
moyenne_MC_theorique = h;  %la variance théorique des paramètres estimés

% Tracé de la moyenne empirique et théorique
figure;
% plot(h, 'b', 'LineWidth', 1.5); hold on;
plot(moyenne_MC, 'g', 'LineWidth', 1.5); hold on;
plot(moyenne_MC_theorique, 'r--', 'LineWidth', 1.5);
legend('moyenne empirique', 'moyenne théorique');
xlabel('Indice k'); ylabel('moyenne');
title('Comparaison entre moyenne empirique et moyenne théorique');
grid on;

% calcul de la variance empirique des réalisations
variance_MC = var(theta_MC_real, 0, 2);

% Affichage des résultats
disp('Moyenne empirique des réalisations theta_MC :'); disp(moyenne_MC);
disp('Variance empirique des réalisations theta_MC :'); disp(variance_MC);

% Calcul de la variance théorique des paramètres estimés
variance_MC_theorique = sigma2 * diag(inv(R' * R));

% Tracé de la variance empirique et théorique
figure;
plot(variance_MC, 'g', 'LineWidth', 1.5); hold on;
plot(variance_MC_theorique, 'r--', 'LineWidth', 1.5);
legend('Variance empirique', 'Variance théorique');
xlabel('Indice k'); ylabel('Variance');
title('Comparaison entre variance empirique et variance théorique');
grid on;

% Calcul du biais des deux méthodes
biais_RI = mean(theta_RI - h);
biais_MC = mean(theta_MC - h);

% Calcul de la variance des deux estimateurs
variance_RI = var(theta_RI);
variance_MC = var(theta_MC);

% Affichage des résultats dans la console
fprintf('Biais de l estimation par impulsion : %.4f\n', biais_RI);
fprintf('Biais de l estimation par moindres carrés : %.4f\n', biais_MC);
fprintf('Variance de l estimation par impulsion : %.4f\n', variance_RI);
fprintf('Variance de l estimation par moindres carrés : %.4f\n', variance_MC);

%% V_ Estimation par moindres carrés et données Aberrantes(optionnel)

% Estimation des paramètres par Moindres Carrés (sans valeurs aberrantes)
theta_MC_sans = (R' * R) \ (R' * y);
y_aberrant = y;  % Création d'une copie de y pour y_aberrant
indices_aberrants = randperm(N, 5);   % Sélection de 5 indices aléatoires 

% Ajout de grandes valeurs aberrantes à ces indices
y_aberrant(indices_aberrants) = y_aberrant(indices_aberrants) + 10 * max(abs(y));

% Estimation des paramètres avec les valeurs aberrantes
theta_MC_avec = (R' * R) \ (R' * y_aberrant);

% Affichage
disp('Paramètres estimés avec valeurs aberrantes :'); disp(theta_MC_avec);

% Tracé de la réponse impulsionnelle estimée avec et sans valeurs aberrantes
figure;
plot(theta_MC_sans, 'b', 'LineWidth', 1.5); hold on;
plot(theta_MC_avec, 'r--', 'LineWidth', 1.5);
legend('Réponse impulsionnelle sans valeurs aberrantes', 'Avec valeurs aberrantes');
xlabel('Indice k'); ylabel('Amplitude');
title('Comparaison de l''estimation avec et sans valeurs aberrantes');
grid on;

% Calcul de l'erreur entre les estimations
erreur_aberrant = norm(theta_MC_sans - theta_MC_avec);

% Affichage de l'erreur
disp('Norme de l''erreur entre theta_MC sans et avec valeurs aberrantes :'); disp(erreur_aberrant);

residu = y_aberrant - R * theta_MC_avec;  % Calcul du résidu d'estimation

% Tracé du résidu pour visualiser les valeurs aberrantes
figure;
plot(residu, 'm', 'LineWidth', 1.5);
xlabel('Indice'); ylabel('Valeur du résidu');
title('Analyse du résidu pour détecter les valeurs aberrantes');
grid on;

% Définition du seuil de détection des valeurs aberrantes (3 fois l'écart-type)
seuil = 3 * std(y_aberrant - R * theta_MC_avec);

% Identification des indices des valeurs aberrantes
indices_aberrants = find(abs(y_aberrant - R * theta_MC_avec) > seuil);

% Affichage des indices détectés
disp('Indices des valeurs aberrantes détectées :'); disp(indices_aberrants);

% Suppression des valeurs aberrantes des données
y_corrige = y_aberrant;            % Copie du signal bruité
y_corrige(indices_aberrants) = []; % Suppression des valeurs aberrantes

% Suppression des lignes correspondantes de la matrice R
R_corrige = R; 
R_corrige(indices_aberrants, :) = [];

% Nouvelle estimation de theta_MC après suppression des valeurs aberrantes
theta_MC_corrige = (R_corrige' * R_corrige) \ (R_corrige' * y_corrige);

% Affichage des résultats
disp('Paramètres estimés après suppression des valeurs aberrantes :'); disp(theta_MC_corrige);

% Tracé des estimations avant et après suppression
figure;
plot(theta_MC_avec, 'r--', 'LineWidth', 1.5); hold on;
plot(theta_MC_corrige, 'g', 'LineWidth', 1.5);
legend('Avec valeurs aberrantes', 'Après suppression');
xlabel('Indice k'); ylabel('Amplitude');
title('Comparaison avant/après suppression des valeurs aberrantes');
grid on;

