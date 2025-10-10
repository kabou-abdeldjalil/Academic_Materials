#!/usr/bin/python
# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as pl

pl.rcParams.update({'font.size': 22})
#====================================================================
# Master 1 SIA       Génération des signaux
#
#                                       jf Trouilhet - Novembre 2023
#====================================================================
#
NbrPts=2048
Fe=44100

t=np.arange(NbrPts)/Fe

#PtsFreq1=int(5500*NbrPts/Fe-25)
#PtsFreq2=int(5500*NbrPts/Fe+25)
f=np.arange(NbrPts)*Fe/NbrPts
#f=f[PtsFreq1:PtsFreq2]

#
###  Base d'apprentissage ########################################################
#
AmpB=0.015  # Amplitude du bruit

print("genere.py : Génération de la base d'apprentissage\n")
NbrFamilleApp=np.array([350, 300, 400, 350])   # 4 familles pour 1400 signaux
Visu=1


y=np.zeros((np.sum(NbrFamilleApp[0:4]), NbrPts),'float')
c=np.zeros((np.sum(NbrFamilleApp[0:4]), 1),'int')

#
### Famille n°1
#
f1=5500-1500*(np.random.rand(NbrFamilleApp[0])-0.5)
a1=1-0.2*(np.random.rand(NbrFamilleApp[0])-0.5)


for i in range(NbrFamilleApp[0]):
    y[i]=np.multiply(a1[i], np.sin(2*np.pi*f1[i]*t))+AmpB*np.random.randn(NbrPts)
    c[i]=1
    if i==Visu :
        pl.figure(i)
        pl.plot(t,y[i],'-')
        pl.xlabel("t (s)")
        pl.grid(True)
        pl.title("Famille 1")

        SpectreM_y=abs(np.fft.fft(y[i]));
        SpectreP_y=np.unwrap(np.angle(np.fft.fft(y[i])))
        #SpectreM_y=SpectreM_y[PtsFreq1:PtsFreq2]
        #SpectreP_y=SpectreP_y[PtsFreq1:PtsFreq2]
        pl.figure(i+1)
        pl.plot(f,20*np.log10(SpectreM_y),'-')
        pl.xlabel("f (Hz)")
        pl.grid(True)
        pl.title("Module spectre famille 1")

        #pl.figure(3*i+3)
        #pl.plot(f,20*SpectreP_y,'-')
        #pl.xlabel("f (Hz)")
        #pl.grid(True)
        #pl.title("Phase spectre famille 1")

        pl.show()
#
### Famille n°2
#
f1=5500-1500*(np.random.rand(NbrFamilleApp[1])-0.5)
Delta=  200*(np.random.rand(NbrFamilleApp[1])-0.5)
f2=f1+100*np.sign(Delta)+Delta
a1=1-0.25*(np.random.rand(NbrFamilleApp[1])-0.5)



for i in range(NbrFamilleApp[1]):
    y[np.sum(NbrFamilleApp[0:1])+i]=0.5*np.multiply(a1[i], (np.sin(2*np.pi*f1[i]*t) + np.cos(2*np.pi*f2[i]*t)))+AmpB*np.random.randn(NbrPts)
    c[np.sum(NbrFamilleApp[0:1])+i]=2

    if i==Visu :
        pl.figure(i+2)
        pl.plot(t,y[np.sum(NbrFamilleApp[0:1])+i],'-')
        pl.xlabel("t (s)")
        pl.grid(True)
        pl.title("Famille 2")

        SpectreM_y=abs(np.fft.fft(y[np.sum(NbrFamilleApp[0:1])+i]));
        SpectreP_y=np.unwrap(np.angle(np.fft.fft(y[np.sum(NbrFamilleApp[0:1])+i])))
        #SpectreM_y=SpectreM_y[PtsFreq1:PtsFreq2]
        #SpectreP_y=SpectreP_y[PtsFreq1:PtsFreq2]
        pl.figure(i+3)
        pl.plot(f,20*np.log10(SpectreM_y),'-')
        pl.xlabel("f (Hz)")
        pl.grid(True)
        pl.title("Module spectre famille 2")

        #pl.figure(3*i+3)
        #pl.plot(f,20*SpectreP_y,'-')
        #pl.xlabel("f (Hz)")
        #pl.grid(True)
        #pl.title("Phase spectre famille 2")

        pl.show()
#
### Famille n°3
#
f1=5500-1500*(np.random.rand(NbrFamilleApp[2])-0.5)
Delta= np.asarray(np.round(800 - 500*(np.random.rand(NbrFamilleApp[2])-0.5)), dtype="int")
a1=1-0.25*(np.random.rand(NbrFamilleApp[2])-0.5)


for i in range(NbrFamilleApp[2]):
    #print(Delta[i])
    y[np.sum(NbrFamilleApp[0:2])+i]=np.multiply(a1[i] ,np.multiply(np.sin(2*np.pi*f1[i]*t), np.concatenate((np.hanning(Delta[i]), np.zeros(NbrPts-Delta[i])), axis=0)))+AmpB*np.random.randn(NbrPts)
    c[np.sum(NbrFamilleApp[0:2])+i]=3

    if i==Visu :
        pl.figure(i+4)
        pl.plot(t,y[np.sum(NbrFamilleApp[0:2])+i],'-')
        pl.xlabel("t (s)")
        pl.grid(True)
        pl.title("Famille 3")

        SpectreM_y=abs(np.fft.fft(y[np.sum(NbrFamilleApp[0:2])+i]));
        SpectreP_y=np.unwrap(np.angle(np.fft.fft(y[np.sum(NbrFamilleApp[0:2])+i])))
        #SpectreM_y=SpectreM_y[PtsFreq1:PtsFreq2]
        #SpectreP_y=SpectreP_y[PtsFreq1:PtsFreq2]
        pl.figure(i+5)
        pl.plot(f,20*np.log10(SpectreM_y),'-')
        pl.xlabel("f (Hz)")
        pl.grid(True)
        pl.title("Module spectre famille 3")

        #pl.figure(3*i+3)
        #pl.plot(f,20*SpectreP_y,'-')
        #pl.xlabel("f (Hz)")
        #pl.grid(True)
        #pl.title("Phase spectre famille 3")

        pl.show()
#
### Famille n°4
#
f1=5500-800*(np.random.rand(NbrFamilleApp[3])-0.5)
f2=7500-1200*(np.random.rand(NbrFamilleApp[3])-0.5)
Delta1= np.asarray(np.round(600 - 200*(np.random.rand(NbrFamilleApp[3])-0.5)), dtype="int")
Delta2= np.asarray(np.round(1000 - 600*(np.random.rand(NbrFamilleApp[3])-0.5)), dtype="int")
a1=1-0.25*(np.random.rand(NbrFamilleApp[3])-0.5)


for i in range(NbrFamilleApp[3]):
    #print(NbrPts, Delta1[i], Delta2[i],NbrPts-Delta1[i]-Delta2[i])
    y[np.sum(NbrFamilleApp[0:3])+i]=np.multiply(a1[i], np.multiply(np.sin(2*np.pi*f1[i]*t), np.concatenate((np.hanning(Delta1[i]), np.zeros(NbrPts-Delta1[i])), axis=0)) + np.multiply(np.sin(2*np.pi*f2[i]*t), np.concatenate((np.zeros(Delta1[i]), np.hanning(Delta2[i]), np.zeros(NbrPts-Delta1[i]-Delta2[i])), axis=0)))+AmpB*np.random.randn(NbrPts)
    c[np.sum(NbrFamilleApp[0:3])+i]=4

    if i==Visu :
        pl.figure(i+6)
        pl.plot(t,y[np.sum(NbrFamilleApp[0:3])+i],'-')
        pl.xlabel("t (s)")
        pl.grid(True)
        pl.title("Famille 4")

        SpectreM_y=abs(np.fft.fft(y[np.sum(NbrFamilleApp[0:3])+i]));
        SpectreP_y=np.unwrap(np.angle(np.fft.fft(y[np.sum(NbrFamilleApp[0:3])+i])))
        #SpectreM_y=SpectreM_y[PtsFreq1:PtsFreq2]
        #SpectreP_y=SpectreP_y[PtsFreq1:PtsFreq2]
        pl.figure(i+7)
        pl.plot(f,20*np.log10(SpectreM_y),'-')
        pl.xlabel("f (Hz)")
        pl.grid(True)
        pl.title("Module spectre famille 4")

        #pl.figure(3*i+3)
        #pl.plot(f,20*SpectreP_y,'-')
        #pl.xlabel("f (Hz)")
        #pl.grid(True)
        #pl.title("Phase spectre famille 4")

        pl.show()

### Sauvegarde base apprentissage
#
print("genere.py : Sauvegarde de la base d'apprentissage\n")

FichierDestination = open("Signaux.txt", "w")
FichierDestination.write("#--------------------------------------------------------\n")
FichierDestination.write("# Fichier généré par genere.py / jft le 29 Nov 2023      \n")
FichierDestination.write("#--------------------------------------------------------\n")

FichierDestination = open("Signaux.txt", "a+")

for i in range(np.sum(NbrFamilleApp[0:4])):
   ligne=np.concatenate((c[i], y[i]), axis=0)
   ligne.tofile(FichierDestination, sep=',', format="%10.4f")
   FichierDestination.write("\n")

FichierDestination.close()

#
###  Base de Test ###################################################################
#
print("genere.py : Génération de la base de test\n")

NbrFamilleTest=np.array([300, 300, 300, 300])   # 4 familles pour 1200 signaux
Visu=1


y=np.zeros((np.sum(NbrFamilleTest[0:4]), NbrPts),'float')
c=np.zeros((np.sum(NbrFamilleApp[0:4]), 1),'int')

#
### Famille n°1
#
f1=5500-1500*(np.random.rand(NbrFamilleApp[0])-0.5)
a1=1-0.2*(np.random.rand(NbrFamilleApp[0])-0.5)

for i in range(NbrFamilleTest[0]):
    y[i]=np.multiply(a1[i], np.sin(2*np.pi*f1[i]*t))+AmpB*np.random.randn(NbrPts)
    c[i]=1

#
### Famille n°2
#
f1=5500-1500*(np.random.rand(NbrFamilleApp[1])-0.5)
Delta=  200*(np.random.rand(NbrFamilleApp[1])-0.5)
f2=f1+100*np.sign(Delta)+Delta
a1=1-0.25*(np.random.rand(NbrFamilleApp[1])-0.5)



for i in range(NbrFamilleTest[1]):
    y[np.sum(NbrFamilleTest[0:1])+i]=0.5*np.multiply(a1[i], (np.sin(2*np.pi*f1[i]*t) + np.cos(2*np.pi*f2[i]*t)))+AmpB*np.random.randn(NbrPts)
    c[np.sum(NbrFamilleTest[0:1])+i]=2
#
### Famille n°3
#
f1=5500-1500*(np.random.rand(NbrFamilleApp[2])-0.5)
Delta= np.asarray(np.round(800 - 500*(np.random.rand(NbrFamilleApp[2])-0.5)), dtype="int")
a1=1-0.25*(np.random.rand(NbrFamilleApp[2])-0.5)


for i in range(NbrFamilleTest[2]):
    #print(Delta[i])
    y[np.sum(NbrFamilleTest[0:2])+i]=np.multiply(a1[i] ,np.multiply(np.sin(2*np.pi*f1[i]*t), np.concatenate((np.hanning(Delta[i]), np.zeros(NbrPts-Delta[i])), axis=0)))+AmpB*np.random.randn(NbrPts)
    c[np.sum(NbrFamilleTest[0:2])+i]=3

#
### Famille n°4
#
f1=5500-800*(np.random.rand(NbrFamilleApp[3])-0.5)
f2=7500-1200*(np.random.rand(NbrFamilleApp[3])-0.5)
Delta1= np.asarray(np.round(600 - 200*(np.random.rand(NbrFamilleApp[3])-0.5)), dtype="int")
Delta2= np.asarray(np.round(1000 - 600*(np.random.rand(NbrFamilleApp[3])-0.5)), dtype="int")
a1=1-0.25*(np.random.rand(NbrFamilleApp[3])-0.5)


for i in range(NbrFamilleTest[3]):
    #print(NbrPts, Delta1[i], Delta2[i],NbrPts-Delta1[i]-Delta2[i])
    y[np.sum(NbrFamilleTest[0:3])+i]=np.multiply(a1[i], np.multiply(np.sin(2*np.pi*f1[i]*t), np.concatenate((np.hanning(Delta1[i]), np.zeros(NbrPts-Delta1[i])), axis=0)) + np.multiply(np.sin(2*np.pi*f2[i]*t), np.concatenate((np.zeros(Delta1[i]), np.hanning(Delta2[i]), np.zeros(NbrPts-Delta1[i]-Delta2[i])), axis=0)))+AmpB*np.random.randn(NbrPts)
    c[np.sum(NbrFamilleTest[0:3])+i]=4

#
### Sauvegarde base test
#
print("genere.py : Sauvegarde de la base de test\n")

FichierDestination = open("SignauxTest.txt", "w")
FichierDestination.write("#--------------------------------------------------------\n")
FichierDestination.write("# Fichier généré par genere.py / jft le 29 Nov 2023      \n")
FichierDestination.write("#--------------------------------------------------------\n")

FichierDestination = open("SignauxTest.txt", "a+")

for i in range(np.sum(NbrFamilleTest[0:4])):

   ligne=np.concatenate((c[i], y[i]), axis=0)
   ligne.tofile(FichierDestination, sep=',', format="%10.4f")
   FichierDestination.write("\n")

FichierDestination.close()
