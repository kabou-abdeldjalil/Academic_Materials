import numpy as np
from scipy.signal import hilbert
import matplotlib.pyplot as plt
import TPClassif2024 as tpc
from ModuleTPClassif import (CalculerIndividusCentresReduits, CalculerVariances,
                             CalculerMatricesCovariance, CalculerCentresGravite)
# Calcul de l'enveloppe des signaux
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))
params = np.array([
    [np.sum(np.square(Enveloppe[i])), np.mean(Enveloppe[i]), np.var(Enveloppe[i])]
    for i in range(len(Enveloppe))
])
CentresGravite = CalculerCentresGravite(params, tpc.NoClasse)
IndividusCentresReduits = CalculerIndividusCentresReduits(params, CentresGravite)
VT, VA, VE = CalculerVariances(IndividusCentresReduits, tpc.NoClasse, CentresGravite)
CT, CA, CE = CalculerMatricesCovariance(IndividusCentresReduits, tpc.NoClasse, CentresGravite)

# **1. Analyse Factorielle Discriminante (AFD)**
# Régularisation de CA
epsilon = 1e-6
CA_reg = CA + epsilon * np.eye(CA.shape[0])
# Calcul de S_W^-1 * S_B
Sw_inv = np.linalg.inv(CA_reg) @ CE
eigvals_afd, eigvecs_afd = np.linalg.eig(Sw_inv)
# Trier les vecteurs propres selon les valeurs propres décroissantes
sorted_indices = np.argsort(eigvals_afd)[::-1]
eigvecs_afd = eigvecs_afd[:, sorted_indices]
# Projeter les données sur les deux premières composantes discriminantes
X_AFD = IndividusCentresReduits @ eigvecs_afd[:, :2]

# **2. Analyse en Composantes Principales (ACP)**
# Centrer les données pour l'ACP
params_centered = params - np.mean(params, axis=0)
# Décomposition en valeurs singulières
_, _, Vt = np.linalg.svd(params_centered)
W_ACP = Vt[:2, :].T  # Deux premières composantes principales
X_ACP = params_centered @ W_ACP

# Plot AFD
plt.figure(figsize=(12, 6));plt.subplot(1, 2, 1)
plt.scatter(X_AFD[:, 0], X_AFD[:, 1], c=tpc.NoClasse, cmap='viridis', edgecolors='k')
plt.title("Analyse Factorielle Discriminante (AFD)")
plt.xlabel("Discriminant 1");plt.ylabel("Discriminant 2");plt.grid()

# Plot ACP
plt.subplot(1, 2, 2)
plt.scatter(X_ACP[:, 0], X_ACP[:, 1], c=tpc.NoClasse, cmap='viridis', edgecolors='k')
plt.title("Analyse en Composantes Principales (ACP)")
plt.xlabel("Composante principale 1");plt.ylabel("Composante principale 2");plt.grid()

plt.tight_layout();plt.show()
