#!/usr/bin/python
# -*- coding: utf-8 -*-
import numpy as np
import TPClassif2024 as tpc
from math import sqrt
import matplotlib.pyplot as plt
from scipy.signal import hilbert

#====================================================================
# Master 1 SIA       Classif signaux
#====================================================================
#                  Lecture de la base d'apprentissage
#====================================================================
#
# NbrIndividus   : nbr de lignes dans le fichier
# NbrVariables   : nbr de colonnes dans la ligne
# MatriceDonnees : Matrice NbrIndividus x NbrParametres
# NoClasse       : Numero de classe de l'indivinu
# 
print("Lecture de la base d'apprentissage.\n")
MatriceDonnees=np.ndarray([], dtype=float)
NoClasse=np.array([], dtype=int)

source = open("Signaux.txt", "r")

NbrIndividus=0
FinFichier=False
while not FinFichier:
      ligne = source.readline().rstrip('\n\r')
      FinFichier = len(ligne)==0
      #print(ligne)

      if (not FinFichier) and (ligne[0:1]!="#"):
             # Extraction des données de la ligne séparées par une virgule
             donnees = ligne.rstrip('\n\r').split(",")
             NbrVariables= len(donnees)-1
             NbrIndividus+=1

             Data=np.array([], dtype=float)
             #print('/',donnees[0].strip(),'/')
             NoClasse=np.append(NoClasse, [int(float(donnees[0].strip()))], axis=0)
             Data=np.array(donnees[1:], dtype=float)
             if NbrIndividus>2:
                 MatriceDonnees= np.append(MatriceDonnees, [Data], axis=0)
             else:
                 if NbrIndividus==2:
                     MatriceDonnees= np.append([MatriceDonnees], [Data], axis=0)
                 else:
                     MatriceDonnees= Data

# Fermerture du fichier source
source.close()
#----------------------------------------------------------------------------
print("Nombre d'individus de la base d'apprentissage : %d"  % NbrIndividus)
print("Nombre de variables de la base d'apprentissage : %d" % NbrVariables)

#====================================================================
#                  Lecture de la base de test
#====================================================================
#
# NbrIndividusTest   : nbr de lignes dans le fichier
# NbrVariablesTest   : nbr de colonnes dans la ligne
# MatriceDonneesTest : Matrice NbrIndividus x NbrParametres
# NoClasseTest       : Numero de classe de l'indivinu
# 
print("\n\nLecture de la base de test.\n")
MatriceDonneesTest=np.ndarray([], dtype=float)
NoClasseTest=np.array([], dtype=int)

source = open("SignauxTest.txt", "r")

NbrIndividusTest=0
FinFichier=False
while not FinFichier:
      ligne = source.readline().rstrip('\n\r')
      FinFichier = len(ligne)==0
      #print(ligne)

      if (not FinFichier) and (ligne[0:1]!="#"):
             # Extraction des données de la ligne séparées par une virgule
             donnees = ligne.rstrip('\n\r').split(",")
             NbrVariablesTest= len(donnees)-1
             NbrIndividusTest+=1

             Data=np.array([], dtype=float)
             #print('/',donnees[0].strip(),'/')
             NoClasseTest=np.append(NoClasseTest, [int(float(donnees[0].strip()))], axis=0)
             Data=np.array(donnees[1:], dtype=float)
             if NbrIndividusTest>2:
                 MatriceDonneesTest= np.append(MatriceDonneesTest, [Data], axis=0)
             else:
                 if NbrIndividusTest==2:
                     MatriceDonneesTest= np.append([MatriceDonneesTest], [Data], axis=0)
                 else:
                     MatriceDonneesTest= Data

# Fermerture du fichier source
source.close()
#----------------------------------------------------------------------------
print("Nombre d'individus de la base de test : %d"  % NbrIndividusTest)
print("Nombre de variables de la base de test : %d" % NbrVariablesTest)
#////////////////////////////////////////////////////////////////////////////////////////////



