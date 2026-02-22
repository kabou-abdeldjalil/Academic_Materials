function sig_hat=Reconstruction(s,w,dec);
% Entrées:
% s: Matrice dont chaque colonne est une tranche débruitée
% w: Largeur de la fenêtre (en nombre d'échantillons)
% dec: Décalage relatif entre 2 tranches succesives (nombre entre 0 et 1)
%%%%%%%%%%%
% Sortie:
% sig_hat: Signal débruité
L2=size(s,2);
dec_N=dec*w;
sig_hat=zeros((L2-1)*dec_N+w,1);
for i=1:L2
    start=(i-1)*dec_N+1;
    s_vec=s(:,i);
    sig_hat(start:start+w-1)=sig_hat(start:start+w-1)+s_vec;
end
end