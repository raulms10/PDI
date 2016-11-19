clear all; close all; clc
load('redNeuronal.mat');
p = x(:,1); %Sacamos un valor del vector de caracteristicas
y = net(p) %Probamos la red