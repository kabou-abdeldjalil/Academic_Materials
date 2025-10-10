import numpy as np
from scipy.signal import hilbert
import TPClassif2024 as tpc
import matplotlib.pyplot as plt

print("Lecture de la base d'apprentissage.\n")
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))
# Visualiser l'enveloppe temporelle pour quelques signaux de chaque classe
for classe in np.unique(tpc.NoClasse):
    indices_classe = np.where(tpc.NoClasse == classe)[0]
    for i in indices_classe[:3]:  # Choisissez quelques signaux à visualiser
        plt.plot(Enveloppe[i], label=f'Classe {classe}, Signal {i+1}')

    plt.xlabel('Temps')
    plt.ylabel("Amplitude de l'enveloppe")
    plt.title(f"Enveloppe Temporelle des signaux par classe - famille {classe}")
    plt.show()


import numpy as np
from scipy.signal import hilbert
import TPClassif2024 as tpc
import matplotlib.pyplot as plt

print("Lecture de la base d'apprentissage.\n")
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))
# Visualiser l'enveloppe temporelle pour quelques signaux de chaque classe
for classe in np.unique(tpc.NoClasse):
    indices_classe = np.where(tpc.NoClasse == classe)[0]
    for i in indices_classe[:3]:  # Choisissez quelques signaux à visualiser
        plt.plot(Enveloppe[i], label=f'Classe {classe}, Signal {i+1}')

plt.xlabel('Temps')
plt.ylabel("Amplitude de l'enveloppe")
plt.title("Enveloppe Temporelle des signaux par classe")
plt.show()



import numpy as np
from scipy.signal import hilbert
import TPClassif2024 as tpc
import matplotlib.pyplot as plt
# Lecture de la base d'apprentissage
print("Lecture de la base d'apprentissage.\n")
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))
# Paramètres de la FFT
N = len(tpc.MatriceDonnees[0])  # Taille du signal (nombre d'échantillons)
frequencies = np.fft.fftfreq(N)  # Fréquences associées à la FFT
fft_signal = np.fft.fft(Enveloppe)  # Appliquer la FFT sur l'enveloppe du signal
# Étudier le contenu fréquentiel de quelques signaux
for classe in np.unique(tpc.NoClasse):
    indices_classe = np.where(tpc.NoClasse == classe)[0]
    for i in indices_classe[:3]:  # Choisir quelques signaux de chaque classe
        # Tracer le spectre de fréquence
        plt.plot(frequencies[:N//2], fft_signal[:N//2], label=f'famille {classe},Signal {i+1}')
        plt.xlabel('Fréquence (Hz)')
        plt.ylabel('Amplitude')
        plt.title("Analyse Fréquentielle des Signaux (Enveloppes)")
        plt.show()


import numpy as np
from scipy.signal import hilbert
import TPClassif2024 as tpc
import matplotlib.pyplot as plt

# Lecture de la base d'apprentissage
print("Lecture de la base d'apprentissage.\n")
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))  # Calcul de l'enveloppe des signaux
# Paramètres de la FFT
N = len(tpc.MatriceDonnees[0])  # Taille du signal
frequencies = np.fft.fftfreq(N)  # Fréquences associées à la FFT
# Afficher l'analyse fréquentielle pour quelques signaux
for classe in np.unique(tpc.NoClasse):
    indices_classe = np.where(tpc.NoClasse == classe)[0]
    for i in indices_classe[:3]:  # Choisir quelques signaux
        # Appliquer la FFT sur l'enveloppe et prendre la moitié du spectre
        fft_signal = np.fft.fft(Enveloppe[i])
        plt.plot(frequencies[:N//2], np.abs(fft_signal)[:N//2], label=f'Classe {classe}, Signal {i+1}')

    # Paramétrer le graphique
    plt.xlabel('Fréquence (Hz)')
    plt.ylabel('Amplitude')
    plt.title("Analyse Fréquentielle des Signaux (Enveloppes)")
    #plt.legend()
    plt.grid(True)
    plt.show()



import numpy as np
from scipy.signal import hilbert
import TPClassif2024 as tpc
import matplotlib.pyplot as plt
# Lecture de la base d'apprentissage
print("Lecture de la base d'apprentissage.\n")
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))  # Calcul de l'enveloppe des signaux
N = len(tpc.MatriceDonnees[0])  # Taille du signal
frequencies = np.fft.fftfreq(N)  # Fréquences associées à la FFT
# Afficher l'analyse fréquentielle pour quelques signaux
for classe in np.unique(tpc.NoClasse):
    indices_classe = np.where(tpc.NoClasse == classe)[0]
    for i in indices_classe[:3]:  # Choisir quelques signaux
        # Appliquer la FFT sur l'enveloppe et obtenir le spectre complet
        fft_signal = np.fft.fft(Enveloppe[i])
        plt.plot(frequencies, np.abs(fft_signal), label=f'Classe {classe}, Signal {i+1}')
# Paramétrer le graphique
plt.xlabel('Fréquence (Hz)');plt.ylabel('Amplitude')
plt.title("Analyse Fréquentielle des Signaux (Enveloppes)");plt.grid(True);plt.show()








import numpy as np
from scipy.signal import hilbert
import TPClassif2024 as tpc
import matplotlib.pyplot as plt
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))  # Calcul de l'enveloppe des signaux
# Extraire les paramètres pour chaque signal
params = []
for classe in np.unique(tpc.NoClasse):
    indices_classe = np.where(tpc.NoClasse == classe)[0]
    for i in indices_classe:  # Pour chaque signal dans la classe
        # Calculer l'énergie, la moyenne et la variance de l'enveloppe
        Energie = np.sum(np.square(Enveloppe[i]))  # Calcul de l'énergie
        Moyenne = np.mean(Enveloppe[i])  # Moyenne de l'enveloppe
        Variance = np.var(Enveloppe[i])  # Variance de l'enveloppe
        # Ajouter les paramètres dans une liste
        params.append([Energie,Moyenne,Variance])
params = np.array(params)
# Affichage des résultats
for i, param in enumerate(params,start=1):
    print(f"Signal {i}:");print(f"  Energie: {param[0]}")
    print(f"  Moyenne de l'enveloppe: {param[1]}")
    print(f"  Variance de l'enveloppe: {param[2]}");print()

    


import numpy as np
from scipy.signal import hilbert
import TPClassif2024 as tpc
Enveloppe = np.abs(hilbert(tpc.MatriceDonnees))  # Calcul de l'enveloppe des signaux
# Initialiser un dictionnaire pour stocker les paramètres par classe
params_by_class = {}
# Calcul des paramètres pour chaque classe
for classe in np.unique(tpc.NoClasse):
    indices_classe = np.where(tpc.NoClasse == classe)[0]
    class_params = []  # Liste des paramètres pour cette classe
    for i in indices_classe:
        # Calcul des paramètres pour chaque signal
        Energie = np.sum(np.square(Enveloppe[i]))
        Moyenne = np.mean(Enveloppe[i])
        Variance = np.var(Enveloppe[i])
        # Ajouter les paramètres du signal à la classe
        class_params.append([Energie, Moyenne, Variance])
    # Convertir en numpy array pour une manipulation plus facile
    params_by_class[classe] = np.array(class_params)
# Affichage des résultats par classe
for classe, params in params_by_class.items():
    print(f"\nClasse {classe} :");print(f"Nombre de signaux : {len(params)}")
    print(f"  Moyenne des energies : {np.mean(params[:, 0]):.2f}")
    print(f"  Moyenne des moyennes d'enveloppe : {np.mean(params[:, 1]):.2f}")
    print(f"  Moyenne des variances d'enveloppe : {np.mean(params[:, 2]):.2f}")
    print(f"  Energie totale : {np.sum(params[:, 0]):.2f}")


