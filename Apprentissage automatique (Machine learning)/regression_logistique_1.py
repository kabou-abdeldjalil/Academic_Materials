# -*- coding: utf-8 -*-
"""
Created on Mon Jan 23 17:23:52 2023

@author: Hosseini
"""

# %matplotlib inline
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.datasets import load_breast_cancer
cancer = load_breast_cancer() # Load dataset
print(cancer.DESCR) # Data description
x = cancer.data[:,0:1] # mean radius
y = cancer.target # 0: malignant, 1: benign
plt.plot(x[y==0],y[y==0],'ro') # Scatter plot of malignant tumors
plt.plot(x[y==1],y[y==1],'bx') # # Scatter plot of benign tumors
plt.xlabel('Mean radius')
plt.ylabel('Result')





