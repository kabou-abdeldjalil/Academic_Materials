# -*- coding: utf-8 -*-
"""
Created on Fri Jan 20 14:28:16 2023

@author: Hosseini
"""

#  %matplotlib inline
import matplotlib.pyplot as plt
import numpy as np
# represents the heights of a group of people in meters
heights = np.array([[1.6], [1.65], [1.7], [1.73], [1.8]])
# represents the weights of a group of people in kgs
weights = np.array([[60], [65], [72.3], [75], [80]])
plt.title('Weights plotted against heights')
plt.xlabel('Heights in meters')
plt.ylabel('Weights in kilograms')
plt.plot(heights, weights, 'k.')
# axis range for x and y
plt.axis([1.5, 1.85, 50, 90])
plt.grid(True)

from sklearn.linear_model import LinearRegression
# Create and fit the model
model = LinearRegression()
model.fit(heights, weights)
# plot the regression line
plt.plot(heights, model.predict(heights), color='r')
# make prediction
weight = model.predict([[1.75]])
print(weight)