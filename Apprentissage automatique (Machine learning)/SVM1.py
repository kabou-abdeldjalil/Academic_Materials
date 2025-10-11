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

df = pd.DataFrame(
	{
		"x1": [0,1,2,2,3],
		"x2" : [0,1,3,0,4],
        "class": ['A','A','B','A','B']
	})


sns.lmplot(data=df, x='x1', y='x2', hue='class', fit_reg=False);
plt.show() 






