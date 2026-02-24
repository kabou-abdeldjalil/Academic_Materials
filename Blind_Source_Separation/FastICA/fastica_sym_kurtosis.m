function [Y, W] = fastica_sym_kurtosis(X, nb_iter)
% FASTICA_SYM_KURTOSIS : FastICA symétrique (kurtosis) pour n sources
% X : n x N (mélanges)
% nb_iter : nombre d'itérations (ex: 50)
% Y : n x N (sources estimées)
% W : n x n (matrice de séparation)

[n, N] = size(X);

% 1) centrage
X = X - mean(X,2);

% 2) blanchiment
Rx = cov(X.');              % n x n
[E, D] = eig(Rx);
M = diag(1 ./ sqrt(diag(D))) * E';
Z = M * X;                  % Z blanchi (n x N)

% 3) initialisation de W (aléatoire) + orthonormalisation
randn('seed',1);
W = randn(n,n);
% orthonormalisation simple via QR
[W, ~] = qr(W);

% 4) itérations FastICA (symétrique)
for it = 1:nb_iter
    
    W_old = W;
    
    % mise à jour de chaque ligne wi
    for i = 1:n
        y = W(i,:) * Z;                         % 1 x N
        W(i,:) = (Z * (y'.^3))'/N - 3*W(i,:);   % 1 x n
    end
    
    % orthogonalisation (symétrique) : W <- (W W^T)^(-1/2) W
    [U,S] = eig(W*W');
    W = (U * diag(1./sqrt(diag(S))) * U') * W;
    
    % critère simple d'arrêt (optionnel)
    if norm(abs(diag(W*W_old')) - ones(n,1)) < 1e-6
        break;
    end
end

% 5) sources estimées
Y = W * Z;
end

