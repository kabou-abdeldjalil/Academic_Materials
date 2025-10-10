import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import TPClassif2024 as tpc
import dernier_etape as dr

from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.cluster import KMeans
from sklearn.neural_network import MLPClassifier
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier

# Division des données
X_train, X_test, y_train, y_test = train_test_split(dr.X_ACP, tpc.NoClasse, test_size=0.2,random_state=None)

# Initialiser et entraîner le modèle K-Means
kmeans = KMeans(n_clusters=4, random_state=42)
kmeans.fit(X_train,y_train)
y_predict_k = kmeans.predict(X_test)
conf_matrix_k = confusion_matrix(y_test,y_predict_k)
a_kmeans = accuracy_score(y_test, y_predict_k)
print(f"Précision (K-Means) :", a_kmeans )

# Initialisation du Perceptron Multicouche
Classif_p = MLPClassifier(hidden_layer_sizes=(100,),max_iter=500,random_state=42)
Classif_p.fit(X_train, y_train)
y_predict_p = Classif_p.predict(X_test)
conf_matrix_p = confusion_matrix(y_test,y_predict_p)
a_p = accuracy_score(y_test, y_predict_p)
print(f"Précision (MLPClassifier) :",a_p)

# Initialisation du classifieur SVM
Classif_M = SVC(kernel='rbf',C=1.0,random_state=42)
Classif_M.fit(X_train, y_train)
y_predict_m = Classif_M.predict(X_test)
conf_matrix_m = confusion_matrix(y_test,y_predict_m)
a_SVM = accuracy_score(y_test, y_predict_m)
print(f"Précision (SVM) :",a_SVM)

# Forêt d'arbres
Classif_F = RandomForestClassifier(n_estimators=100,random_state=42)
Classif_F.fit(X_train, y_train)
y_predict_f = Classif_F.predict(X_test)
conf_matrix_f = confusion_matrix(y_test,y_predict_f)
a_RF = accuracy_score(y_test, y_predict_f)
print(f"Précision (Random Forest) :",a_RF)

plt.figure(figsize=(12, 10))
plt.scatter(X_train[:,0], X_train[:,1],c = y_train,cmap='viridis', edgecolors='k')
plt.title("Analyse en Composantes Principales (ACP)")
plt.xlabel("Composante principale 1");plt.ylabel("Composante principale 2");plt.grid()

plt.figure(figsize=(12, 10))
plt.subplot(2,2,1)
plt.scatter(X_test[:,0], X_test[:,1],c = y_predict_k,cmap='viridis', edgecolors='k')
plt.title("'K-means'")
plt.grid()
plt.subplot(2,2,2)
plt.scatter(X_test[:,0], X_test[:,1],c = y_predict_p,cmap='viridis', edgecolors='k')
plt.title("'MLP'")
plt.grid()
plt.subplot(2,2,3)
plt.scatter(X_test[:,0], X_test[:,1],c = y_predict_m,cmap='viridis', edgecolors='k')
plt.title("'SVM'")
plt.grid()
plt.subplot(2,2,4)
plt.scatter(X_test[:,0], X_test[:,1],c = y_predict_f,cmap='viridis', edgecolors='k')
plt.title("'Random Forest'")
plt.grid()
plt.show()

plt.figure(figsize=(15, 10))
plt.subplot(2,2,1)
sns.heatmap(conf_matrix_k, annot = True, fmt = 'd',cmap='Blues', cbar=False)
plt.title("Matrice de confusion - 'K-means'")
plt.subplot(2,2,2)
sns.heatmap(conf_matrix_p, annot = True, fmt = 'd',cmap='Blues', cbar=False)
plt.title("Matrice de confusion - 'MPL'")
plt.subplot(2,2,3)
sns.heatmap(conf_matrix_m, annot = True, fmt = 'd',cmap='Blues', cbar=False)
plt.title("Matrice de confusion - 'SVM'")
plt.subplot(2,2,4)
sns.heatmap(conf_matrix_f, annot = True, fmt = 'd',cmap='Blues', cbar=False)
plt.title("Matrice de confusion - 'Random Forest'")
plt.show()