%% TP2 statistiques

clear all
clc
close all

% Réalisé par : GHENAI ISLEM et KABOU Abdeldjalil

load('X.mat');

%% Analyse en composantes principales (ACP)

% Première étude : Réflectance des matériaux

%% 1. Calcul des valeurs propres de la matrice de covariance  
[n,p] = size(X);

C =cov(X) ; % la matrice de covariance
%1 valeur propres : 
%E = eig(C) ;
[V,D] = eig(C);

E= diag(D);
E= abs(E);

[E,Idx]=sort(E,'descend');
V=V(:,Idx);
semilogy(E,'linewidth',1.5);title('les valeurs propres associées au axes principeaux') ;grid on
%% 2. tracer les 10 premières valeurs propres
plot(E(1:10,:),'linewidth',1.5);title('les 10 premières valeurs propres') ;grid on

%% 3. Pourcentage d\'inertie expliqué en fonction de la dimension
I_tot = sum (E) ; 
I_k = [];
for k=1:length(E)
I = sum(E(1:k)) / I_tot ;
I_k = [ I_k I];

end
plot(I_k,'LineWidth',1.5);grid on ; title(' le pourcentage dinertie en fonction de dimension de sous espace')

%% 4. Pourcentage d\'inertie expliqué pour les 10 premières composantes 

I_tot = sum (E) ; 
I_k = [];
for k=1:10
I = sum(E(1:k)) / I_tot ;
I_k = [ I_k I];

end
plot(I_k,'LineWidth',1.5);grid on ; title(' le pourcentage dinertie en prenant seulement 10 sous espaces')

%% 5. Représentation du nuage de points projeté sur un sous-espace de dimension 1 


Z= X*V; % Z le vecteur qui contient les projection des données sur le sous espace
X_proj1 =Z(:,1); % on prend la premiere ocmpostante principale
plot(X_proj1,zeros(27,1),'o',LineWidth=2) ;grid on ; title(' représentation des nuages  de points sur une seul dimension') 


%% 6. Représentation du nuage de points projeté sur un sous-espace de dimension 2

Z= X*V; % Z le vecteur qui contient les projection des données sur le sous espace
X_proj2 =Z(:,1:2); % on prend la premiere ocmpostante principale

plot(X_proj2(:,1),X_proj2(:,2),'o',LineWidth=2) ;grid on ; title(' représentation des nuages  de points sur un espaces de 2 dimensions') 

%% 7. Affichage des valeurs de la première composante principale

display (' les valeurs de la première ocmpostante princiaple')
display(V(:,1))



%% Analyse en composantes principales (ACP)

% Deuxième étude : Réflectance des matériaux


%% chargement et rassemblement des données

load('ign_crs.mat');
[n1,p1] = size(ign_crs);% nombre n d'individus et p variables de la classe 1 

load('ign_fn.mat');
[n2,p2] = size(ign_fn);% nombre n d'individus et p variables de la classe 2

load('sed_crs.mat');
[n3,p3] = size(sed_crs);% nombre n d'individus et p variables de la classe 3

% rassembles des 3 classes en une seul matrice
X= [ign_crs ;ign_fn ; sed_crs] ; 

[n,p] = size(X);% nombre n d'individus et p variables de la base de données complète


%% Représentation 2D avec les variables 1 et 2

plot(X(1:n1,1),X(1:n1,2),'o',LineWidth=2) ;grid on ; hold on ;
plot(X(n1+1:n1+n2,1),X(n1+1:n1+n2,2),'X',LineWidth=2);grid on ; hold on
plot(X(n2+n1+1:end,1),X(n1+n2+1:end,2),'*',LineWidth=2);grid on ; title(' Représentation des nuages de points des 3 classes');legend('classe 1','classe 2','classe 3')

%% Représentation 2D avec les variables 1 et p

plot(X(1:n1,1),X(1:n1,p),'o',LineWidth=2) ;grid on ; hold on ;
plot(X(n1+1:n1+n2,1),X(n1+1:n1+n2,p),'X',LineWidth=2);grid on ; hold on
plot(X(n2+n1+1:end,1),X(n1+n2+1:end,p),'*',LineWidth=2);grid on ; title(' Représentation des nuages de points en considérant les variables 1 et p ');legend('classe 1','classe 2','classe 3')


%% ACP (même principe que la section 1)
%################################################################################

%% 1) Calcul des valeurs propres 

C =cov(X) ; % la matrice de covariance
%1 valeur propres : 
%E = eig(C) ;
[V,D] = eig(C);

E= diag(D);
E= abs(E);

[E,Idx]=sort(E,'descend');
V=V(:,Idx);
semilogy(E,'linewidth',1.5);title('les valeurs propres associées au axes principeaux') ;grid on

%% 2) Les 10 premières valeurs propres (échelle linéaire)

plot(E(1:10,:),'linewidth',1.5);title('les 10 premières valeurs propres') ;grid on

%% 3) Pourcentage d''inertie expliqué (toutes dimensions)

I_tot = sum (E) ; 
I_k = [];
for k=1:length(E)
I = sum(E(1:k)) / I_tot ;
I_k = [ I_k I];

end
plot(I_k,'LineWidth',1.5);grid on ; title(' le pourcentage dinertie en fonction de dimension de sous espace')

%% 4) Pourcentage d'inertie des 10 premiers sous ensemble 

I_tot = sum (E) ; 
I_k = [];
for k=1:10
I = sum(E(1:k)) / I_tot ;
I_k = [ I_k I];

end
plot(I_k,'LineWidth',1.5);grid on ; title(' le pourcentage dinertie en prenant seulement 10 sous espaces')

%% 5) Projection en dimension 1 (nuage avec classes) 

Z= X*V; % Z le vecteur qui contient les projection des données sur le sous espace
X_proj1 =Z(:,1); % on prend la premiere ocmpostante principale
%plot(X_proj1,zeros(27,1),'o',LineWidth=2) ;grid on ; title(' représentation des nuages  de points sur une seul dimension') 

plot(X_proj1(1:n1),zeros(n1,1),'o',LineWidth=2) ;grid on ; hold on ;
plot(X_proj1(n1+1:n1+n2),zeros(n2,1),'X',LineWidth=2);grid on ; hold on
plot(X_proj1(n2+n1+1:end),zeros(n3,1),'*',LineWidth=2);grid on ; title(' Représentation des nuages de points des 3 classes');legend('classe 1','classe 2','classe 3')


%% 6) Projection en dimension 2 (nuage avec classes) 

Z= X*V; % Z le vecteur qui contient les projection des données sur le sous espace
X_proj2 =Z(:,1:2); % on prend la premiere ocmpostante principale

plot(X_proj2(1:n1,1),X_proj2(1:n1,2),'o',LineWidth=2) ;grid on ; hold on ;
plot(X_proj2(n1+1:n1+n2,1),X_proj2(n1+1:n1+n2,2),'X',LineWidth=2);grid on ; hold on
plot(X_proj2(n2+n1+1:end,1),X_proj2(n2+n1+1:end,2),'*',LineWidth=2);grid on ; title(' Représentation des nuages de points des 3 classes');legend('classe 1','classe 2','classe 3')


%% AFD 

% Étude de la réflectance

%% chargement et rassemblement des données

load('ign_crs.mat');
[n1,p1] = size(ign_crs);% nombre n d'individus et p variables de la classe 1 

load('ign_fn.mat');
[n2,p2] = size(ign_fn);% nombre n d'individus et p variables de la classe 2

load('sed_crs.mat');
[n3,p3] = size(sed_crs);% nombre n d'individus et p variables de la classe 3

% rassembles des 3 classes en une seul matrice
X= [ign_crs ;ign_fn ; sed_crs] ; 

[n,p] = size(X);% nombre n d'individus et p variables de la base de données complète

%% Calcul de l'AFD : 
% calcul de la matrice de covariance C :

C = cov(X);
% calcul des centres de gravité :
g1= mean(X(1:n1,:) )';
g2= mean(X(n1+1:n1+n2,:) )';
g3= mean(X(n1+n2+1:end,:) )';
g= mean(X)';

% calcul des des poids qj 
q1 = n1/n ; 
q2=n2/n;
q3=n3/n;

% et enfin on calcul B : 
B1= q1*(g1 - g)*(g1 - g)' ;
B2= q2*(g2 - g)*(g2 - g)' ;
B3= q3*(g3 - g)*(g3 - g)' ;
B=B1+B2+B3;
%% calculer et tracer les valeur propres  : 
%E = eig(C) ;
[V,D] = eig(inv(C)*B);

E= diag(D);
E= abs(E);

[E,Idx]=sort(E,'descend');
V=V(:,Idx);
semilogy(E,'linewidth',1.5);title('les valeurs propres associées au axes discriminantes') ;grid on;
xlabel('indices');ylabel('module des valeurs propres ');

%% 2) Les 10 premières valeurs propres (échelle linéaire)

plot(E(1:10),'linewidth',1.5);title('les valeurs propres associées au axes discriminantes') ;grid on;
xlabel('indices');ylabel('module des 10 premières valeurs propres');

%% 3) Projection des données sur un sous-espace de dimension 1 

Z= X*V; % Z le vecteur qui contient les projection des données sur le sous espace
X_proj1 = Z(:,1); 
%plot(X_proj1,zeros(27,1),'o',LineWidth=2) ;grid on ; title(' représentation des nuages  de points sur une seul dimension') 

plot(X_proj1(1:n1),zeros(n1,1),'o',LineWidth=2) ;grid on ; hold on ;
plot(X_proj1(n1+1:n1+n2),zeros(n2,1),'X',LineWidth=2);grid on ; hold on
plot(X_proj1(n2+n1+1:end),zeros(n3,1),'*',LineWidth=2);grid on ; title(' Représentation des nuages de points des 3 classes');legend('classe 1','classe 2','classe 3')

%% 4) Projection des données sur un sous-espace de dimension 2

X_proj2 =Z(:,1:2);

plot(X_proj2(1:n1,1),X_proj2(1:n1,2),'o',LineWidth=2) ;grid on ; hold on ;
plot(X_proj2(n1+1:n1+n2,1),X_proj2(n1+1:n1+n2,2),'X',LineWidth=2);grid on ; hold on
plot(X_proj2(n2+n1+1:end,1),X_proj2(n2+n1+1:end,2),'*',LineWidth=2);grid on ; title(' Représentation des nuages de points des 3 classes');legend('classe 1','classe 2','classe 3')

