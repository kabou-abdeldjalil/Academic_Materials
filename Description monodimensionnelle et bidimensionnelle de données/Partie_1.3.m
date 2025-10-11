
clear all
clc
close all

%% Partie 3 : Etude des données synthétiques

% 1. générer les données et représentation des points : 
    
n=30 % on aura 2n+1 points
alpha_1 = 2; alpha_2 = 1;
X_1= []; %initialisation 
X_2= []; %initialisation 
y=[5 1];% point de coordonnées quelconque
for i= -n:n 
X_1= [X_1 alpha_1*i ] ;%les abscisses des points     

X_2= [X_2  alpha_2*i ];% les oordonnées des points
end
X_1= [X_1 y(1)];
X_2= [X_2 y(2)];
X= [ X_1 ; X_2];% regrouper les points dans une seul matrice X
% Représentation des nuages de pointns : 
plot(X(1,1:end-1), X(2,1:end-1), 'bo', 'MarkerSize', 8, 'LineWidth', 1.5); % Points réguliers en bleu
hold on;
plot(X(1,end), X(2,end), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'red'); % Point spécial en rouge rempli
hold off; 
xlabel('x_1', 'FontSize', 12);
ylabel('x_2', 'FontSize', 12);
title('Représentation des nuages de points', 'FontSize', 14);
grid on; % Ajouter une grille
axis equal; % Même échelle sur les deux axes
legend('Points réguliers', 'Point de coordonnées qeélconques y', 'Location', 'best'); % Légende


%% Partie 3 : Etude des données synthétiques
n_values = [];
R= [];
for k= 1:50 % on fait varier n 
    
n=k % on aura 2n+1 points
n_values = [n_values n]
alpha_1 = 2; alpha_2 = 1;
X_1= []; %initialisation 
X_2= []; %initialisation 
y=[5 1];
for i= -n:n 
X_1= [X_1 alpha_1*i; ] ;%les abscisses des points     

X_2= [X_2  alpha_2*i; ];% les oordonnées des points
end
X_1= [X_1 y(1)];
X_2= [X_2 y(2)];
X= [ X_1 ; X_2];% regrouper les points dans une seul matrice X

% Calcul du coefficient de corrélation entre les deux variables : 
Xt= X' ; % les lignes sont les individus , colonnes : variables 
Xc_1 = Xt(:,1)- (mean( Xt(:,1) )*ones(2*n+2,1) ); % variables centrée réduite
Xc_2 = Xt(:,2)- (mean( Xt(:,2) )*ones(2*n+2,1) ); % variables centrée réduite

coeff_corr = (Xc_1'*Xc_2)/(vecnorm(Xc_1) * vecnorm(Xc_2));
R= [R coeff_corr ];
end

figure(2)
plot(n_values, R,'LineWidth', 1.5) ;grid on ; 
xlabel('n'); ylabel('Coefficient de corrélation');
title('Évolution du coefficient de corrélation en fonction de n ');


%% Partie 3 : Étude en fonction de y1 quand y2=0
n = 30; 
alpha_1 = 2; alpha_2 = 1;
y2 = 0;
y1_values = -20:20;
R_y1 = [];

for y1 = y1_values
    X1 = [alpha_1*(-n:n), y1];
    X2 = [alpha_2*(-n:n), y2];
    
    X1c = X1 - mean(X1);
    X2c = X2 - mean(X2);
    rho = (X1c*X2c')/(norm(X1c)*norm(X2c));
    R_y1 = [R_y1 rho];
end

figure(4)
plot(y1_values, R_y1,'LineWidth',1.5);
xlabel('y^1'); ylabel('Coefficient de corrélation');
title('Corrélation en fonction de y^1 avec y^2 = 0');
grid on;
