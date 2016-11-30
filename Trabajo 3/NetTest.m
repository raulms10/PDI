clear all; close all; clc
load('redNeuronal.mat');

nombre = ['00011'  '.ppm']; % Creamos el nombre de la imagen
img1 = imread(fullfile('.\Test',nombre)); % leemos la imagen y la pasamos a double
C=8;
img = double(rgb2gray(img1));
img1=rgb2hsv(img1);
[fil, col, cap] = size(img1);
fC = [];
roja1=0; verde1=0; azul1=0;
for f=1:fil
    for c=1:col
        roja1 = roja1 + double(img1(f,c,1));
        verde1 = verde1 + double(img1(f,c,2));
        azul1 = azul1 + double(img1(f,c,3));
    end
end
comp1 = [roja1, verde1, azul1]/(fil*col); %Sacamos un valor del vector de caracteristicas
comp1 = comp1';
%Cuadrante 1 de la imagen
imgC1 = img(1:fil/2,1:col/2); 
[Y, lambda, A, Xs] = pca(imgC1,'NumComponents', C);%'Rows', 'all'); %Realiza un analisis PCA de img y retorna Xs con C caracteristicas(descritor)
C1 = lambda(1,:)';
disp('Cuadrante 1');
yC1 = net(C1)
%Cuadrante 1 de la imagen
imgC2 = img(1:fil/2,col/2:col); 
[Y, lambda, A, Xs] = pca(imgC2,'NumComponents', C);%'Rows', 'all'); %Realiza un analisis PCA de img y retorna Xs con C caracteristicas(descritor)
C2 = lambda(1,:)';
disp('Cuadrante 2')
yC2 = net(C2)
%Cuadrante 1 de la imagen
imgC3 = img(fil/2:fil,1:col/2); 
[Y, lambda, A, Xs] = pca(imgC3,'NumComponents', C);%'Rows', 'all'); %Realiza un analisis PCA de img y retorna Xs con C caracteristicas(descritor)
C3 = lambda(1,:)';
disp('Cuadrante 3')
yC3 = net(C3)*1.5
%Cuadrante 1 de la imagen
imgC4 = img(fil/2:fil,col/2:col); 
[Y, lambda, A, Xs] = pca(imgC4,'NumComponents', C);%'Rows', 'all'); %Realiza un analisis PCA de img y retorna Xs con C caracteristicas(descritor)
C4 = lambda(1,:)';
disp('Cuadrante 4')
yC4 = net(C4)*1.5

m = [yC1, yC2, yC3, yC4];
maxC1 = find(yC1==max(yC1));
maxC2 = find(yC2==max(yC2));
maxC3 = find(yC3==max(yC3));
maxC4 = find(yC4==max(yC4));

maximos=[max(yC1), max(yC2), max(yC3), max(yC4)];
posMax = find(maximos==max(maximos));
if posMax==1
    pos = find(yC1 == maximos(posMax));
elseif posMax==2
    pos = find(yC2 == maximos(posMax));
elseif posMax==3
    pos = find(yC3 == maximos(posMax));
else
    pos = find(yC4 == maximos(posMax));
end
disp(10-pos);



    
 
% y = net() %Probamos la red