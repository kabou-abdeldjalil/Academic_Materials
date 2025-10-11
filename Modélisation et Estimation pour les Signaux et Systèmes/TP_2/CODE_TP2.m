%% TP3 – Modélisation et Estimation par Moindres Carrés

%% Q2.1 & Q2.2 : Construction de la matrice R et estimation des paramètres β

load('dataMC_2025.mat'); 
N = length(y);

% Construction de la matrice R et du vecteur y_target
R = zeros(N-2, 4); 
for n = 3:N
    R(n-2, :) = [y(n-1), y(n-2), x(n), x(n-1)];
end
y_target = y(3:N);

% Estimation des paramètres β = [a1, a2, b0, b1]
beta_hat = R \ y_target;

% Affichage des paramètres estimés
fprintf('Paramètres estimés :\n');
fprintf('a1 = %.4f\n', beta_hat(1));
fprintf('a2 = %.4f\n', beta_hat(2));
fprintf('b0 = %.4f\n', beta_hat(3));
fprintf('b1 = %.4f\n', beta_hat(4));


%% Q2.3 : Calcul de la réponse impulsionnelle h[n] estimée

a1 = beta_hat(1); a2 = beta_hat(2);
b0 = beta_hat(3); b1 = beta_hat(4);
h_est = zeros(size(h));
h_est(1) = b0;
h_est(2) = b1 + a1 * h_est(1);

for n = 3:length(h)
    h_est(n) = a1 * h_est(n-1) + a2 * h_est(n-2);
end

n = 0:length(h_est)-1;
figure;
plot(n, h_est, 'b', 'LineWidth', 1.5);
xlabel('n'); ylabel('Amplitude');
title('Réponse impulsionnelle estimée h[n]');
grid on;

% Comparaison avec la réponse théorique
figure;
plot(h, 'r--'); hold on;
plot(h_est, 'b');
legend('Théorique', 'Estimée');
title('Comparaison entre h_{théorique} et h_{estimée}');
xlabel('n'); ylabel('h[n]');

% Calcul de l’erreur de l’estimation
NE = norm(h - h_est);
disp(['Erreur normée : ', num2str(NE)]);

%%
  %%%%%%%%%%% partie 3 %%%%%%%%%%%%%%  

%% Q4.3 : Estimation par la méthode de Steiglitz-McBride

max_iter = 20;
tol = 1e-6;
beta_smb = beta_hat;
a_coeff = [1, -beta_smb(1), -beta_smb(2)];
beta_history = zeros(max_iter+1, 4); % pour traçage
beta_history(1,:) = beta_smb';

for iter = 1:max_iter
    y_filt = filter(1, a_coeff, y);
    x_filt = filter(1, a_coeff, x);
    
    R_filt = zeros(N-2, 4);
    for n = 3:N
        R_filt(n-2, :) = [y_filt(n-1), y_filt(n-2), x_filt(n), x_filt(n-1)];
    end
    y_target_filt = y_filt(3:N);
    
    beta_new = R_filt \ y_target_filt;
    beta_history(iter+1,:) = beta_new';
    
    if norm(beta_new - beta_smb) < tol
        break;
    end
    beta_smb = beta_new;
    a_coeff = [1, -beta_smb(1), -beta_smb(2)];
end

fprintf('\nParamètres estimés par Steiglitz-McBride :\n');
disp(beta_smb);

% Tracé de l’évolution des paramètres
figure;
plot(0:iter, beta_history(1:iter+1,1), 'o-'); hold on;
plot(0:iter, beta_history(1:iter+1,2), 's-');
plot(0:iter, beta_history(1:iter+1,3), 'd-');
plot(0:iter, beta_history(1:iter+1,4), '^-');
title('Évolution des paramètres \beta');
xlabel('Itération');
ylabel('Valeur estimée');
legend('a1', 'a2', 'b0', 'b1');
grid on;

%%
  %%%%%%%%%%% partie 4 %%%%%%%%%%%%%%  

%% Partie III –Biais et variance sur les paramètres estimés

%1. Analyse par simulations Monte Carlo

Nr = 200;
sigma2 = 0.3;
beta_all = zeros(Nr, 4);

for k = 1:Nr
    epsilon_k = sqrt(sigma2) * randn(size(x));
    y_k = conv(x, h); y_k = y_k(1:length(x));
    y_k = y_k + epsilon_k;

    R = zeros(length(y_k)-2, 4);
    Y_target = y_k(3:end);
    for n = 3:length(y_k)
        R(n-2,:) = [y_k(n-1), y_k(n-2), x(n), x(n-1)];
    end
    beta_init = R \ Y_target;

    beta_smb = beta_init;
    a_coeff = [1, -beta_smb(1), -beta_smb(2)];
    for iter = 1:30
        y_filt = filter(1, a_coeff, y_k);  
        x_filt = filter(1, a_coeff, x);
        Rf = zeros(length(y_k)-2, 4);
        for n = 3:length(y_k)
            Rf(n-2,:) = [y_filt(n-1), y_filt(n-2), x_filt(n), x_filt(n-1)];
        end
        beta_new = Rf \ y_filt(3:end);
        if norm(beta_new - beta_smb) < 1e-6
            break;
        end
        beta_smb = beta_new;
        a_coeff = [1, -beta_smb(1), -beta_smb(2)];
    end
    beta_all(k, :) = beta_smb';
end

%Q1. Estimation de la moyenne, variance et biais de β
% Moyenne et variance
beta_mean = mean(beta_all, 1);
beta_var = var(beta_all, 0, 1);
fprintf('\nMoyenne empirique des paramètres :\n');
disp(beta_mean);
fprintf('Variance empirique :\n');
disp(beta_var);

% Calcul du biais
beta_theo = [2*exp(-lambda)*cos(2*pi*f), ...
             -exp(-2*lambda), ...
             A*sin(phi), ...
             A*exp(-lambda)*sin(2*pi*f + phi)];
beta_bias = beta_mean - beta_theo;
fprintf('Biais empirique :\n');
disp(beta_bias);

%% Q5.3 : Analyse des estimations de h[n]

P = length(h);
H_est_all = zeros(Nr, P);
for k = 1:Nr
    a1 = beta_all(k,1); a2 = beta_all(k,2);
    b0 = beta_all(k,3); b1 = beta_all(k,4);
    h_k = zeros(1, P);
    h_k(1) = b0;
    h_k(2) = a1 * b0 + b1;
    for n = 3:P
        h_k(n) = a1 * h_k(n-1) + a2 * h_k(n-2);
    end
    H_est_all(k, :) = h_k;
end
%Q2. Calcul de la moyenne, variance et biais de h[n]:
% Statistiques
h = h(:).';
h_mean = mean(H_est_all, 1);
h_var = var(H_est_all, 0, 1);
h_bias = h_mean - h;


% Affichage
fprintf('\nErreur quadratique moyenne entre h_mean et h réel : %.6f\n', norm(h_mean - h));
fprintf('Erreur quadratique moyenne du biais : %.6f\n', norm(h_bias));


figure;
plot(n, h, 'k', 'LineWidth', 2); hold on;
plot(n, h_mean, 'b--', 'LineWidth', 1.5);
xlabel('n'); ylabel('Amplitude');
legend('h[n] réelle', 'Moyenne des h[n] estimées');
title('Comparaison entre h réelle et moyenne estimée');



% Tracé du biais 
n = 0:P-1;
figure;
plot(n, h_bias, 'g', 'LineWidth', 1.5);
xlabel('n'); ylabel('Biais');
title('Biais moyen de l’estimateur de h[n]');
grid on;


figure;
plot(n, h_var, 'm', 'LineWidth', 1.5);
xlabel('n'); ylabel('Variance');
title('Variance empirique de l’estimateur de h[n]');
grid on;


%% V.2 - Estimation du biais et de la variance par la méthode du Bootstrap

%% Données nécessaires : x, h, A, lambda, f, phi
Nr = 200; % Nombre de réalisations bootstrap
N = length(x);

%% Q1. Estimation initiale de beta_hat et résidus
% Estimation initiale des paramètres sur les données originales (Steiglitz-McBride)
R = zeros(N-2, 4);
for n = 3:N
    R(n-2, :) = [y(n-1), y(n-2), x(n), x(n-1)];
end
y_target = y(3:N);
beta_hat = R \ y_target;
a_coeff = [1, -beta_hat(1), -beta_hat(2)];

% Estimation de la sortie du modèle avec beta_hat
y_model = zeros(size(y));
y_model(1:2) = y(1:2);
for n = 3:N
    y_model(n) = beta_hat(1)*y_model(n-1) + beta_hat(2)*y_model(n-2) + beta_hat(3)*x(n) + beta_hat(4)*x(n-1);
end

% Calcul des résidus
res = y - y_model;



% Affichage des paramètres estimés
disp('Paramètres estimés beta_hat = [a1, a2, b0, b1] :');
disp(beta_hat);

% Affichage d'un extrait de la sortie modélisée (facultatif)
disp('Aperçu des premières valeurs de y_model :');
disp(y_model(1:10));

% Affichage des résidus (facultatif, car c’est un long vecteur)
disp('Aperçu des premières valeurs des résidus :');
disp(res(1:10));

% Tracé pour visualiser la sortie réelle vs modélisée
figure;
plot(y, 'r', 'DisplayName', 'y réelle'); hold on;
plot(y_model, 'b--', 'DisplayName', 'y modélisée');
legend;
xlabel('n'); ylabel('Amplitude');
title('Comparaison entre y réelle et y modélisée');
grid on;

% Tracé des résidus
figure;
plot(res, 'k');
xlabel('n'); ylabel('Amplitude');
title('Résidus : y[n] - y_M[n]');
grid on;

%% Q2. Réalisations fictives par tirage aléatoire avec remise (Bootstrap)
y_boot_all = zeros(Nr, N);
beta_boot_all = zeros(Nr, 4);

for k = 1:Nr
    idx = randi(length(res), 1, N); % tirage aléatoire avec remise
    res_k = res(idx);
    y_k = y_model + res_k; % sortie fictive

    % Estimation Steiglitz-McBride sur y_k
    R = zeros(N-2, 4);
    for n = 3:N
        R(n-2, :) = [y_k(n-1), y_k(n-2), x(n), x(n-1)];
    end
    y_target = y_k(3:N);
    beta_init = R \ y_target;
    beta_smb = beta_init;
    a_coeff = [1, -beta_smb(1), -beta_smb(2)];

    for iter = 1:30
        y_filt = filter(1, a_coeff, y_k);
        x_filt = filter(1, a_coeff, x);
        Rf = zeros(N-2, 4);
        for n = 3:N
            Rf(n-2,:) = [y_filt(n-1), y_filt(n-2), x_filt(n), x_filt(n-1)];
        end
        beta_new = Rf \ y_filt(3:end);
        if norm(beta_new - beta_smb) < 1e-6
            break;
        end
        beta_smb = beta_new;
        a_coeff = [1, -beta_smb(1), -beta_smb(2)];
    end
    beta_boot_all(k, :) = beta_smb';
end


% Affichage : aperçu des 5 premières estimations
disp('Aperçu des 5 premières estimations beta^(k) :');
disp(beta_boot_all(1:5, :));


%% Q3. Calcul des statistiques sur beta
beta_boot_mean = mean(beta_boot_all);
beta_boot_var = var(beta_boot_all);

% Théorique
beta_theo = [2*exp(-lambda)*cos(2*pi*f), ...
             -exp(-2*lambda), ...
             A*sin(phi), ...
             A*exp(-lambda)*sin(2*pi*f + phi)];

beta_boot_bias = beta_boot_mean - beta_theo;

% Affichage
fprintf('Moyenne bootstrap beta :\n'); disp(beta_boot_mean);
fprintf('Variance bootstrap beta :\n'); disp(beta_boot_var);
fprintf('Biais bootstrap beta :\n'); disp(beta_boot_bias);

%% Q4. Calcul de h[n] pour chaque beta^(k)
P = length(h);
H_boot_all = zeros(Nr, P);

for k = 1:Nr
    a1 = beta_boot_all(k,1); a2 = beta_boot_all(k,2);
    b0 = beta_boot_all(k,3); b1 = beta_boot_all(k,4);
    h_k = zeros(1, P);
    h_k(1) = b0;
    h_k(2) = a1*b0 + b1;
    for n = 3:P
        h_k(n) = a1*h_k(n-1) + a2*h_k(n-2);
    end
    H_boot_all(k,:) = h_k;
end

% Moyenne, variance et biais de h[n]
h_boot_mean = mean(H_boot_all);
h_boot_var = var(H_boot_all);
h_boot_bias = h_boot_mean - h;

%% Q5. Affichage
n = 0:P-1;

figure;
plot(n, h, 'k', 'LineWidth', 2); hold on;
plot(n, h_boot_mean, 'b--', 'LineWidth', 1.5);
legend('h[n] réelle', 'Moyenne des h[n] Bootstrap');
xlabel('n'); ylabel('Amplitude');
title('Comparaison h réelle et h Bootstrap');
grid on;

figure;
plot(n, h_boot_bias, 'g', 'LineWidth', 1.5);
xlabel('n'); ylabel('Biais');
title('Biais Bootstrap de h[n]');
grid on;

figure;
plot(n, h_boot_var, 'm', 'LineWidth', 1.5);
xlabel('n'); ylabel('Variance');
title('Variance Bootstrap de h[n]');
grid on;
