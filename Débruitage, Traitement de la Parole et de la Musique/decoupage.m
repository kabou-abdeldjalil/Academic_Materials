function x=decoupage(sig,fen,w,dec)
% Entrées:
% sig: Signal audio
% fen: Fenêtre multipliée par le signal
% w: Largeur de la fenêtre (en nombre d'échantillons)
% dec: Décalage relatif entre 2 tranches succesives (nombre entre 0 et 1)
%%%%%%%%%%%
% Sortie:
% x: Matrice dont chaque colonne correspond à une tranche de signal
L=length(sig);
dec_M=floor(w.*dec); % Décalage, converti en nombre d'échantilllons
N=floor((L-w)/dec_M +1); %nombre de tranches
for i=1:N
    x(:,i)=sig((i-1)*dec_M+1:(i-1)*dec_M+w).*fen;
end
end