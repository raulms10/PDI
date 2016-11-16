clear all; close all; clc
load('redNeuronal.mat');
p = x(:,2); %Sacamos un valor del vector de caracteristicas
y = net(p) %Probamos la red