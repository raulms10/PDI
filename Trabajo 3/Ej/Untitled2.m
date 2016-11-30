clear all;close all,clc
load('redNeuronal.mat');
x = irisInputs(:,120);
y = net(x)