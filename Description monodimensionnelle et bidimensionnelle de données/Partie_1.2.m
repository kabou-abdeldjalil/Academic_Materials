function calcul_histo = calcul_hist(X,m)

% % 1 : domaine de variation de la variable (réflectace des matériaux) : 
val_min = min(min(X));val_max = max(max(X));
i=0;
val = val_min;
val_abs = [];%vecteur pour stocker les centres des intervales des valeurs
pas = (val_max - val_min ) / m; % la longueur de chaque intervalle

hist = []; % histogramme pour stocker les fréquences d'occurences
 while val< val_max 
 val = val_min + i * pas ; 
 f= sum(sum( X >= val & X < val+pas));
 hist = [hist f];
 val_abs = [val_abs val+(pas/2)];
 i=i+1;
 end
 plot(val_abs,hist);grid on ;xlabel('valeurs');ylabel('fréquences doccurences')
 title (' histogramme')
 

h(1,:) = hist; % regrouper les fréquences d'occurences et les valeurs ( centres d'intervalles) en une matrice
h(2,:) = val_abs ;

calcul_histo = h;
end

% Histogrammes
figure; H10 = calcul_hist(X, 10);
figure; H20 = calcul_hist(X, 20);

% Moyenne sur toutes les valeurs
mu = mean(X(:));

% Mode par classe
[~,i10]   = max(H10(1,:)); mode10 = H10(2,i10);
[~,i20]   = max(H20(1,:)); mode20 = H20(2,i20);

fprintf('Moyenne = %.6f | Mode(m=10) ≈ %.6f | Mode(m=20) ≈ %.6f\n', mu, mode10, mode20);
