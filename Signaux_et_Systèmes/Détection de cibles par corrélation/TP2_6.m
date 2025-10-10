clear all
close all
clc

n=1:1000;
x=cos(2*pi*0.1*n+2*pi*rand);

moy=mean(x)
var=var(x)