% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created Wed Nov 02 10:56:57 COT 2016
%
% This script assumes these variables are defined:
%
%   irisInputs - input data.
%   irisTargets - target data.
clear all;close all;clc
%load('redNeuronal.mat');
C=15;
x = [];
for i=1:10
    nombre = ['0000' num2str(i) '.png']; % Creamos el nombre de la imagen
    img = imread(fullfile('C:\Users\lis\Desktop\PDI\Train',nombre)); % leemos la imagen y la pasamos a double
    img = double(img(:,:,1));
    %disp(img);
    [Y, lambda, A, Xs] = pca(img,'NumComponents', C);%'Rows', 'all'); %Realiza un analisis PCA de img y retorna Xs con C caracteristicas(descritor)
    x = horzcat(x, Xs(:)); %Concatenamos el vector de caracteriscas de cada imagen
end
%x = irisInputs;
t = xlsread('target.xlsx'); %Target de cada imagen

% Create a Pattern Recognition Network
% hiddenLayerSize = 10;
net = patternnet([90, 75], 'trainscg'); %Creamos el tipos de red

% Setup Division of Data for Training, Validation, Testing
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 15/100;


% Train the Network
[net,tr] = train(net,x,t); %Entramos y obtenemos la red
save('redNeuronal.mat'); %Guardamos la variables del workspace

nntraintool;
plotperform(tr);
testX = x(:, tr.testInd);
testT = t(:, tr.testInd);
testY = net(testX);
testYindices = vec2ind(testY);
testTindices = vec2ind(testT);
[c, cm] = confusion(testT, testY);
plotconfusion(testT, testY);