%% 
clear all
clc
close all

%% 1.1.1 Données considérées

load('X.mat');        % chargement des données
[n,p] = size(X);      % taille de la matrice X 

%% 1.1.2 Représentation partielle des données - Qs 1

subplot(3,1,1)
plot(X(:,1))
xlabel('Indice i des individus')
ylabel('Variable j=1')
title('Variable 1 en fonction des individus')

subplot(3,1,2)
plot(X(:,2))
xlabel('Indice i des individus')
ylabel('Variable j=2')
title('Variable 2 en fonction des individus')

subplot(3,1,3)
plot(X(:,p))
xlabel('Indice i des individus')
ylabel('Variable j=p')
title('Variable p en fonction des individus')

%% 1.1.2 Représentation partielle des données - Qs 2

% Représentation des nuages de points
subplot(1,2,1)
plot(X(:,1), X(:,2), '+')
xlabel('Variable j=1')
ylabel('Variable j=2')
title('Nuage de points : variables 1 et 2')

subplot(1,2,2)
plot(X(:,1), X(:,p), '+')
xlabel('Variable j=1')
ylabel('Variable j=p')
title('Nuage de points : variables 1 et p')

%% 1.1.2 Représentation partielle des données - Qs 3

% Représentation des individus en fonction des variables (spectres)
subplot(3,1,1)
plot(1:p, X(1,:))
xlabel('Indice j des variables')
ylabel('Réflectance')
title('Spectre de l individu 1')

subplot(3,1,2)
plot(1:p, X(2,:))
xlabel('Indice j des variables')
ylabel('Réflectance')
title('Spectre de l individu 2')

subplot(3,1,3)
plot(1:p, X(n,:))
xlabel('Indice j des variables')
ylabel('Réflectance')
title('Spectre de l individu n')

%% 1.1.3 Analyse monodimensionnelle - Qs 1

% Méthode matricielle
W = eye(n)/n;
m1 = X' * W * ones(n,1); 
m1 = m1';   % vecteur ligne

% Méthode avec la fonction mean()
m2 = mean(X);

% Tracer les résultats
subplot(3,1,1)
plot(1:p, m1, 'b')
xlabel('Indice j des variables')
ylabel('Moyenne')
title('Moyenne des variables - méthode matricielle')

subplot(3,1,2)
plot(1:p, m2, 'r')
xlabel('Indice j des variables')
ylabel('Moyenne')
title('Moyenne des variables - fonction mean()')

subplot(3,1,3)
plot(1:p, m1 - m2, 'g')
xlabel('Indice j des variables')
ylabel('Différence')
title('Différence entre les deux méthodes')

%% 1.1.3 Analyse monodimensionnelle - Qs 2

% Calcul de l'écart-type par la méthode matricielle
C1 = (X' * W * X) - (m1' * m1); 
S1 = sqrt(diag(C1));

% Calcul de l'écart-type avec la fonction std de MATLAB
%S2 = std(X);   % non biaisé (par défaut)
S2 = std(X,1);   % biaisé

% Tracer les résultats
subplot(3,1,1)
plot(S1)
xlabel('Indice j des variables')
ylabel('Écart-type')
title('Écart-type par méthode matricielle')

subplot(3,1,2)
plot(S2)
xlabel('Indice j des variables')
ylabel('Écart-type')
title('Écart-type par la fonction std')

subplot(3,1,3)
plot(S1 - S2')
xlabel('Indice j des variables')
ylabel('Différence')
title('Différence entre les deux méthodes')


%% 1.1.4 Analyse bidimentionnelle

% calcul de la matrice de covariance :
A   = eye(n) - (ones(n,1)* (ones(n,1)') ) / n ;
Y   = A * X ;
Cov = (Y' * Y )/n ; 

D   = 1./S1 ; 
D   = diag(D);

R1  = D * C1 * D;
R2  = corrcoef(X); % par la fonction de matlab

%  traçage de la courbe de variation du coeff de corrélation entre la variable 1 et j
figure;
plot(R1(1,:))
xlabel('Indice j des variables')
ylabel('r(1,j)')
title('Courbe de variation du coeff de corrélation entre la variable 1 et j')

%  validation des résultats : moyenne des corrélations par diagonale
mR = [];
for j = 1:p-1
    moyR = mean(diag(R1,j));
    mR   = [mR moyR];
end

figure;
plot(mR)
xlabel('Décalage k')
ylabel('Corrélation moyenne')
title('Corrélation moyenne en fonction du décalage k')

