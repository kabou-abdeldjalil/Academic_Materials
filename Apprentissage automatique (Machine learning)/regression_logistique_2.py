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

from sklearn import linear_model
log_regress = linear_model.LogisticRegression()

log_regress.fit(x,y)
print(log_regress.intercept_) 
print(log_regress.coef_) 


y_predict_proba=log_regress.predict_proba(x)
plt.plot(x,y_predict_proba[:,1],'g.')

y_predict=log_regress.predict(x)
plt.plot(x,y_predict,'k*')




