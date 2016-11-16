clear all;close all; clc
load('redNeuronal.mat');
p = x(:,10);
y = net(p)