#  TP2 – Sparse Component Analysis (LI-TEMPROM / LI-TEMPCORR)

**Titre complet :** Séparation aveugle de sources par l’analyse en composantes parcimonieuses  
Université Paul Sabatier – M2 SIA (Audio-Vidéo)  
UE : Apprentissage automatique et séparation de sources  

---

##  Objectif du TP

Ce TP a pour objectif de séparer deux sources à partir de deux mélanges **sans فرض الاستقلالية الإحصائية** (contrairement à FastICA).

On exploite l’existence de **zones mono-sources** (moments où une seule source est active), ce qui rend les signaux **parcimonieux** dans le domaine temporel.

Méthodes étudiées :

- **LI-TEMPROM** : détection des zones mono-sources via le **rapport** \( x₂(t) / x₁(t) \)
- **LI-TEMPCORR** : détection des zones mono-sources via des critères de **corrélation**

---

##  1) Génération d’un mélange artificiel (2 sources)

### Étapes réalisées
- Chargement des deux sources depuis `S.mat`
- Analyse temporelle des sources et identification des zones mono-sources
- Mesure de la corrélation entre \( s₁ \) et \( s₂ \)
- Mélange des sources avec la matrice :

\[
A=
\begin{pmatrix}
1 & 0.7\\
0.8 & 1
\end{pmatrix}
\]

---

##  2) Méthode LI-TEMPROM

### Idée
Dans une zone mono-source :
- le rapport \( r(t)=x₂(t)/x₁(t) \) devient presque **constant**
- la variance du rapport dans la zone devient **faible**

### Étapes
- Découpage des observations en zones d’analyse de taille **M = 1000**
- Calcul de la variance du rapport dans chaque zone
- Détection des zones mono-sources (variance faible)
- Estimation des colonnes de la matrice de mélange à partir des zones détectées
- Construction d’une estimation finale de A (regroupement / moyenne des colonnes)
- Séparation des sources via :

\[
\hat{s}(t)=\hat{A}^{-1}x(t)
\]

---

##  3) Méthode LI-TEMPCORR

### Idée
Dans une zone mono-source :
- le coefficient de corrélation \(|\rho_{x₁x₂}|\) devient proche de **1**
- le paramètre \( C = E\{x₁x₂\}/E\{x₁^2\} \) est relié aux colonnes de A

### Étapes
- Détection des zones mono-sources via \(|\rho|\)
- Estimation des colonnes de A via le critère basé sur \(C\)
- Séparation des sources artificielles puis test sur audio

---

##  4) Tests audio

Fichiers fournis :
- `audio_mix1_tp3.wav`
- `audio_mix2_tp3.wav`

### Étapes
- Écoute des 2 mélanges
- Application des méthodes LI-TEMPROM / LI-TEMPCORR
- Écoute des signaux séparés
- Conclusion sur la qualité de séparation (et influence de la taille M)

---

##  Conclusion

- Ces méthodes fonctionnent bien quand les sources présentent des **zones mono-sources** claires.
- Le choix de **M** est important :
  - grand M : détection plus stable mais moins précise temporellement
  - petit M : meilleure localisation mais plus sensible au bruit
- Par rapport à FastICA :
  - avantage : pas besoin d’indépendance statistique
  - limite : dépend fortement de l’existence de zones mono-sources

---

##  Contenu du dépôt

- `CODE_TP2_KABOU.m` → Script Matlab (implémentation LI-TEMPROM / LI-TEMPCORR)
- `Compte rendu TP2.pdf` → Rapport détaillé
- `S.mat` → Sources artificielles fournies
- `audio_mix1_tp3.wav` → Mélange audio 1
- `audio_mix2_tp3.wav` → Mélange audio 2
- Images de l’énoncé (pages 0004 à 0005)

---

##  Énoncé du TP

<p align="center">
  <img src="TP_SAS_Audio_video_page-0004.jpg" width="700">
</p>

<p align="center">
  <img src="TP_SAS_Audio_video_page-0005.jpg" width="700">
</p>

---
TP réalisé dans le cadre du cours  
**Apprentissage automatique et séparation de sources**  
Université Paul Sabatier – Toulouse
