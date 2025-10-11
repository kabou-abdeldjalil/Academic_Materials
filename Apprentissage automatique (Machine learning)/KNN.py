# -*- coding: utf-8 -*-
"""
Created on Mon Jan 23 17:23:52 2023

@author: Hosseini
"""

# %matplotlib inline
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn import datasets

iris = datasets.load_iris()
X = iris.data[:, :2] # take the first two features
y = iris.target







