%PLANTILLA DE CÓDIGO ----------------------------------------------
%------- Coceptos básicos de PDI-------------------------------------------
%------- Por: Raúl Martínez Silgado    rantonio.martinez@udea.edu.co ------
%-------      Estudiante Facultad de Ingenieria  --------------------------
%-------      CC 1010063118, Cel 3045712116 Wpp 3045712116 ----------------
%------- Por: Imran Mirza Orozco    imran.mirza@udea.edu.co ---------------
%-------      Estudiante Facultad de Ingenieria BLQ -----------------------
%-------      CC 1017200544, Cel 3003773294,  Wpp 3003773294 --------------
%------- Curso Básico de Procesamiento de Imágenes y Visión artificial-----
%------- V1 Octubre de 2016

function varargout = tarea2(varargin)
% TAREA2 MATLAB code for tarea2.fig
%      TAREA2, by itself, creates a new TAREA2 or raises the existing
%      singleton*.
%
%      H = TAREA2 returns the handle to a new TAREA2 or the handle to
%      the existing singleton*.
%
%      TAREA2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAREA2.M with the given input arguments.
%
%      TAREA2('Property','Value',...) creates a new TAREA2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tarea2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tarea2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tarea2

% Last Modified by GUIDE v2.5 21-Oct-2016 06:10:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tarea2_OpeningFcn, ...
                   'gui_OutputFcn',  @tarea2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before tarea2 is made visible.
function tarea2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tarea2 (see VARARGIN)

% Choose default command line output for tarea2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tarea2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tarea2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in abririmagen.
function abririmagen_Callback(hObject, eventdata, handles)
% hObject    handle to abririmagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[archivo, ruta] = uigetfile({'*.tiff';'*.png';'*.jpg';'*.bmp';'*.*'},'Seleccione una imagen');
if isequal(archivo,0)
   disp('Operacion cancelada');
   return;
end
set(handles.archivo, 'string', archivo);
set(handles.ruta, 'string', ruta);
img = imread(fullfile(ruta, archivo));
subplot (handles.imagenoriginal),imshow(img);


% --- Executes on button press in btnprocesar.
function btnprocesar_Callback(hObject, eventdata, handles)
% hObject    handle to btnprocesar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc; %limpiamos la linea de comandos
archivo = get(handles.archivo, 'string'); %obtenemos el esqueje a leer
ruta = get(handles.ruta, 'string'); %obtenemos la ruta del esqueje
if isequal(archivo,'nada') %comprobamos que si haya seleccionado un esqueje
   disp('No ha seleccionado una foto'); 
   return;
end
% clear all; close all; clc;
a = imread(fullfile(ruta, archivo)); %leeamos la imagen del esqueje
cform=makecform('srgb2cmyk'); %creamos el form para convertir la imagen
a4=applycform(a,cform); %convertimos la imagen aplicando el form creado
a4=double(a4); %convertimos la imagen a double para luego precesarla
a4=a4/max(a4(:))*255; %binarizamos la imagen
a4=uint8(a4); %y la convertimos a uint8 para mostrarla 
c = a4(:,:,3); % obtenemos la capa 3(capa 'yellow' de cmyk) de la imagen

%figure(12); imshow(c); impixelinfo;

c(c<150) = 0; %le aplicamos un umbral de 150 a la imagen y los hacemos 0
c(c>0) = 255; %y para los otros valores pongo 255

ee = strel('disk', 3); %creamos nuestro elemento estructurante
c = imopen(c, ee); %hacemos una erosión y dilatación a la imagen
[l,n] = bwlabel(c); %sacamos la matriz de etiquetas a la imagen

areaT = []; %definimos un vector de area vacio
d = zeros(size(c)); % cramos una imagen en blanco del mismo tamaño de la original
for i=1:n %recorremos la matriz de etiquetas
    d(l==i)=1; %conseguimos la parte correspondiente al indice actual
    area = sum(d(:)); %calculamos el area de la etiqueta actual
    areaT = [areaT, area]; %añadimos esta area al vector de etiqueta
    d = zeros(size(c)); %reiniciamos la imagen en blanco
end
d = max(areaT(:)); %obtenemos el area máxima del vector de area
set(handles.areaRes, 'string', ['Area: ',num2str(d/100), ' mm^2 ']); %mostramos el area en la GUI
e = zeros(size(c)); d = find(areaT == d); %hallamos el indice del area máxima en el vector de areas
e(l==d)=255; %conseguimos la maqueta o esquema de la imagen
% figure(1); imshow(e); impixelinfo 
m = bwmorph(e,'skel', Inf); %obtemos el esqueleto de la imagen
ends = bwmorph(m, 'endpoints'); %conseguimos los puntos finales del esqueleto
[fF, cC] = find(ends>0); %encontramos la ubicacion de los puntos finales del esqueleto en la imagen
%izq
menCol = find(cC == min(cC)); %encontramos el punto en que se halla la menor columna
izqFil = [fF(menCol)]; izqCol = [cC(menCol)]; %actualizamos las coordenadas del punto de la izquierda
%der
mayCol = find(cC == max(cC)); %encontramos el punto en que se halla la mayor columna
derFil = [fF(mayCol)]; derCol = [cC(mayCol)]; %actualizamos las coordenadas del punto de la derecha
%arr
menFil = find(fF == min(fF)); %encontramos el punto en que se halla la menor fila
arrFil = [fF(menFil)]; arrCol = [cC(menFil)]; %actualizamos las coordenadas del punto de arriba
%aba
mayFil = find(fF == max(fF)); %encontramos el punto en que se halla la mayor fila
abaFil = [fF(mayFil)]; abaCol = [cC(mayFil)]; %actualizamos las coordenadas del punto de abajo
%unico valor, puede que obtengamos los valores a repetidos
izqFil = izqFil(1); izqCol = izqCol(1); %sacamos el primer valor del punto de la izquierda
derFil = derFil(1); derCol = derCol(1); %sacamos el primer valor del punto de la derecha
arrFil = arrFil(1); arrCol = arrCol(1); %sacamos el primer valor del punto de arriba
abaFil = abaFil(1); abaCol = abaCol(1); %sacamos el primer valor del punto de abajo

%salida, comprobar
disp('izq');
disp([izqFil,izqCol]);
disp('der');
disp([derFil,derCol]);
disp('arr');
disp([arrFil,arrCol]);
disp('aba');
disp([abaFil,abaCol]);

cte = 250; %este valor sera el tamaño del cuadrado para determinar la posicion del tallo
[fil, col] = size(e); %obtenemos el tamaño de la imagen
%parte izquierda
iniFil = max([izqFil-cte, 1]); %actualizamos el valor de menor fila por si supera los límites de la imagen
finFil = min([izqFil+cte, fil]); %actualizamos el valor de mayor fila por si supera los límites de la imagen
iniCol = izqCol; %definimos la primera fila del lado de la izquierdo
finCol = min([izqCol+cte*2, col]); %actualizamos el valor de mayor fila por si supera los límites de la imagen
izqLim = [iniFil, finFil, iniCol, (iniCol+finCol)/2]; %armamos el cuadramos del lado izquierdo como vector
cIzq = ends(iniFil:finFil, iniCol:finCol); %sacamos el cuadrado de la imagen de puntos finales del esqueleto
sIzq = sum(cIzq(:)); %sumamos la cantidad de puntos finales en el cuadrado
disp(['izqS: ', num2str(sIzq)]); %mostramos el resultado 

%parte derecha
iniFil = max([derFil-cte, 1]); %actualizamos el valor de menor fila por si supera los límites de la imagen
finFil = min([derFil+cte, fil]); %actualizamos el valor de mayor fila por si supera los límites de la imagen
iniCol = max([derCol-cte*2, 1]); %actualizamos el valor de menor columna por si supera los límites de la imagen
finCol = derCol; %definimos la mayor columna del lado derecho
derLim = [iniFil,finFil, (iniCol+finCol)/2, finCol]; %armamos el cuadramos del lado derecho como vector
cDer = ends(iniFil:finFil, iniCol:finCol); %sacamos el cuadrado de la imagen de puntos finales del esqueleto
sDer = sum(cDer(:)); %sumamos la cantidad de puntos finales en el cuadrado
disp(['derS: ', num2str(sDer)]); %mostramos el resultado 

%parte arriba
iniFil = arrFil; %definimos la menor fila del lado izquierdo
finFil = min([arrFil+cte*2, fil]); %actualizamos el valor de mayor fila por si supera los límites de la imagen
iniCol = max([arrCol-cte, 1]); %actualizamos el valor de menor columna por si supera los límites de la imagen
finCol = min([arrCol+cte, col]); %actualizamos el valor de mayor fila por si supera los límites de la imagen
arrLim = [iniFil, (iniFil+finFil)/2, iniCol, finCol];  %armamos el cuadramos del lado de arriba como vector
cArr = ends(iniFil:finFil, iniCol:finCol);  %sacamos el cuadrado de la imagen de puntos finales del esqueleto
sArr = sum(cArr(:)); %sumamos la cantidad de puntos finales en el cuadrado
disp(['arrS: ', num2str(sArr)]); %mostramos el resultado 

%parte abajo
iniFil = max([abaFil-cte*2, 1]); %actualizamos el valor de mayor fila por si supera los límites de la imagen
finFil = abaFil; %definimos la mayor fila del lado de abajo
iniCol = min([abaCol-cte, 1]); %actualizamos el valor de menor columna por si supera los límites de la imagen
finCol = min([abaCol+cte, col]); %actualizamos el valor de mayor fila por si supera los límites de la imagen
abaLim = [(iniFil+finFil)/2, finFil, iniCol, finCol]; %armamos el cuadramos del lado de arriba como vector
cAba = ends(iniFil:finFil, iniCol:finCol); %sacamos el cuadrado de la imagen de puntos finales del esqueleto
sAba = sum(cAba(:)); %sumamos la cantidad de puntos finales en el cuadrado
disp(['abaS: ', num2str(sAba)]); %mostramos el resultado

%guardar los limites
limites = [izqLim; derLim; arrLim; abaLim]; %guardamos los limites de cada cuadrado
sumas = [sIzq, sDer, sArr, sAba]; %guardamos las sumas de cada cuadrado

%encontrar la posicion del menor numero de puntes alrededor de los puntos
%maximos
posEsq = find(sumas == min(sumas)); %encontramos la posicion de la menor suma en ese lado es probable que esté el tallo del esqueje
cEsq = m(limites(posEsq,1):limites(posEsq,2),limites(posEsq,3):limites(posEsq,4)); %sacamos el cuadrado del donde es probable que esté el esqueje de la imagen de maqueta
cEsq1 = e(limites(posEsq,1):limites(posEsq,2),limites(posEsq,3):limites(posEsq,4)); %sacamos el cuadrado del donde es probable que esté el esqueje de la imagen del esqueleto
% figure(2); imshow(cEsq); impixelinfo;
% figure(3); imshow(cEsq1); impixelinfo;

[filas,columnas] = find(cEsq > 0); %hallamos los puntos validos, que no son cero, del cuadrado
disp('regresion');
[r,p,b] = regression(columnas,filas,'one'); % calculamos la recta que se ajusta a los puntos del cuadrado del tallo
an = atan(p); %hallamos el valor de la pendiente en radianes
% an = radtodeg(r.to);
an = an*180/pi; %convertimos el angulo de la pendiente en grados
disp(an);
a = imrotate(a,an); %rotamos la imagen segun el angulo de la pendiente
% figure(4); imshow(a); impixelinfo;
% figure(5); plotregression(columnas,filas);
e = imrotate(e, an); %rotamos la imagen segun el angulo de la pendiente
m = imrotate(m,an); %rotamos la imagen segun el angulo de la pendiente
% figure(2); imshow(m); impixelinfo;
ends = bwmorph(m, 'bridge'); %hallamos los puntos donde se divide el esqueleto pero de la imagen rotatda

[fF, cC] = find(ends>0); %hallamos los puntos validos del esqueleto del cuadrado 
%izq
menCol = find(cC == min(cC)); %hallamos la menor columna del cuadrado
izqFil = [fF(menCol)]; izqCol = [cC(menCol)]; %actualizamos las coordenadas del punto de la izquierda
%der
mayCol = find(cC == max(cC)); %hallamos la mayor fila del cuadrado
derFil = [fF(mayCol)]; derCol = [cC(mayCol)]; %actualizamos las coordenadas del punto de la derecha

%unico valor
izqFil = izqFil(1); izqCol = izqCol(1); %sacamos un único valor por si existen repetidos
derFil = derFil(1); derCol = derCol(1); %sacamos un único valor por si existen repetidos

if(posEsq == 1 || (posEsq == 3 && an > 0 ) || (posEsq == 4 && an < 0)) %comprobamos la posición del tallo
    %recorremos la imagen de izquierda a derecha
    sumaIni = e(:,izqCol); %sacamos el valor inicial del columna de la izquierda
    sumaIni = sum(sumaIni(:)); %sumanos sus valores
    i = izqCol; %inicializamos el valor del contador
    while(i < derCol) %recorremos hasta alcanzar la mayor columna
        nSumaIni = e(:, i); %sacamos el valor actual del columna
        nSumaIni = sum(nSumaIni(:)); %sumanos sus valores
        %disp([nSumaIni, sumaIni]);
        if(abs(nSumaIni - sumaIni) > 10000) % lo comparamos con el valor anterior
            distTallo = i - izqCol; %actualizamos la distancia al tallo
            a(:, i:i+5, 1) = 255; %ponemos la capa roja de la imagen en su máximo valor
            a(:, i:i+5, 2:3) = 0; %ponemos las demás capas de la imagen en su mínimo valor
            i = derCol + 1; %actualizamos el valor del contaador para romper el ciclo
        end
        i = i + 1; %incrementamos el contador
    end
else
    %recorremos la imagen de derecha a izquierda
    sumaIni = e(:,derCol); %sacamos el valor inicial del columna de la derecha
    sumaIni = sum(sumaIni(:)); %sumanos sus valores
    i = derCol; %inicializamos el valor del contador
    while(i > izqCol) %recorremos hasta alcanzar la menor columna
        nSumaIni = e(:, i); %sacamos el valor actual del columna
        nSumaIni = sum(nSumaIni(:)); %sumanos sus valores
        %disp([nSumaIni, sumaIni, nSumaIni - sumaIni]);
        if(abs(nSumaIni - sumaIni) > 10000) %lo comparamos con el valor anterior
            distTallo = derCol - i; %actualizamos la distancia al tallo
            a(:, i:i+5, 1) = 255; %ponemos la capa roja de la imagen original en su máximo valor
            a(:, i:i+5, 2:3) = 0; %ponemos las demás capas de la imagen en su mínimo valor
            i = izqCol - 1; %actualizamos el valor del contaador para romper el ciclo
        end
        i = i - 1; %disminuimos el contador
    end
end
% figure(3); imshow(a); impixelinfo;
subplot (handles.imagenprocesada),imshow(a); %mostramos la imagen procesada al lado derecho

%salida, comprobar
disp('222222'); 
disp('izq');
disp([izqFil,izqCol]);
disp('der');
disp([derFil,derCol]);
dist = derCol-izqCol; %calcumamos la mayor distancia del esqueje el pixeles
disp(dist);
tam = dist*9.58/690.695; %convertimos la mayor distancia del esqueje en centímetros
set(handles.longMaxRes, 'string', ['Longitud Máxima: ',num2str(tam), ' cm']); %mostramos la mayor distancia en la GUI


%distTallo = stats/2;
distTallo = distTallo*9.58/690.695; %convertimos la distancia al tallo en centímetros
distTallo = distTallo*10; %pasamo a milímetros
set(handles.disTalloRes, 'string', ['Distancia hasta 1er hoja: ', num2str(distTallo), ' mm']); %mostramos la distancia al tallo en al GUI
%subplot (handles.imagenprocesada),imshow(a);

lMax = str2double(get(handles.longMax, 'string')); %obtenemos la longuitud máxima ingresada por el usuario
lMin = str2double(get(handles.longMin, 'string')); %obtenemos la longuitud mínima ingresada por el usuario
tallo = str2double(get(handles.disTallo, 'string')); %obtenemos la distancia al tallo ingresada por el usuario
if(tam > lMax) %comprobamos con la distancia  máxima del esqueje
    set(handles.tipo, 'string', 'Tipo: Largo'); %mostramos la salida respectiva en la GUI
else
    if (tam < lMin) %comprobamos con la distancia  mínima del esqueje
        set(handles.tipo, 'string', 'Tipo: Corto'); %mostramos la salida respectiva en la GUI
    else
        if (distTallo < tallo) %comprobamos con la distancia de hoja en base
            set(handles.tipo, 'string', 'Tipo: Hoja en base'); %mostramos la salida respectiva en la GUI
        else
            set(handles.tipo, 'string', 'Tipo: Ideal'); %mostramos la salida respectiva en la GUI
        end
    end
end
% figure(7); imshow(m); impixelinfo;
% % % % % % % % % % stats = regionprops(e, 'all');
% % % % % % % % % % o = stats.Orientation;
% % % % % % % % % % dist = stats.MajorAxisLength;
% % % % % % % % % % tam = dist*9.58/690.695;
% % % % % % % % % % set(handles.longMaxRes, 'string', ['Longitud MÃ¡xima: ',num2str(tam), ' cm']);
% % % % % % % % % % disp(o);
% % % % % % % % % % if o < -5
% % % % % % % % % %     an=-90+o;
% % % % % % % % % % elseif o > 5
% % % % % % % % % %     an=0-o;
% % % % % % % % % % else
% % % % % % % % % %     an = 0;
% % % % % % % % % % end
% % % % % % % % % % disp(an);
% % % % % % % % % % % e(l==d)=255;
% % % % % % % % % % distTallo = stats.EquivDiameter/2;
% % % % % % % % % % distTallo = distTallo*9.58/690.695;
% % % % % % % % % % set(handles.disTalloRes, 'string', ['Distancia hasta 1er hoja: ', num2str(distTallo)]);
% % % % % % % % % % a = imrotate(a,an); %imagen rotada
% % % % % % % % % % %subplot (handles.imagenprocesada),imshow(a);
% % % % % % % % % % figure(2); imshow(a); impixelinfo;
% % % % % % % % % % lMax = str2double(get(handles.longMax, 'string'));
% % % % % % % % % % lMin = str2double(get(handles.longMin, 'string'));
% % % % % % % % % % tallo = str2double(get(handles.disTallo, 'string'));
% % % % % % % % % % if(tam > lMax)
% % % % % % % % % %     set(handles.tipo, 'string', 'Tipo: Largo');
% % % % % % % % % % else
% % % % % % % % % %     if (tam < lMin)
% % % % % % % % % %         set(handles.tipo, 'string', 'Tipo: Corto');
% % % % % % % % % %     else
% % % % % % % % % %         if (abs(distTallo - tallo) < 0.5)
% % % % % % % % % %             set(handles.tipo, 'string', 'Tipo: Hoja en base');
% % % % % % % % % %         else
% % % % % % % % % %             set(handles.tipo, 'string', 'Tipo: Ideal');
% % % % % % % % % %         end
% % % % % % % % % %     end
% % % % % % % % % % end
% disp(tam);
% figure(2); imshow(a); impixelinfo;
% ee = strel('square', 3);
% f = imdilate(e, ee);
% ee = strel('disk', 10);
% g = imopen(e, ee);
% 
% figure(3); imshow(f); impixelinfo
% figure(4); imshow(g); impixelinfo
% area total limpia de cualquier cosa

% 
% d = bwmorph(g,'skel', Inf);
% figure(3); imshow(d); impixelinfo
% % ends = bwmorph(d, 'branchpoints');
% d = bwmorph(d,'clean');
% ends = bwmorph(d, 'endpoints');
% 
% %puen = bwmorph(d,'bridge');
% figure(4); imshow(ends); impixelinfo;
% % 
% disp('pos');
% [fil,col] = find(d>0);
% newA = ends(ends>0)
% ends(ends>0)=1;
% % puntos mas lejanos
% izqX = 2000;
% derX = 0;
% arrY = 2000;
% abaY = 0;
% [fil, col] = size(ends);
% for i=1:fil
%     for j=1:col
%         if(ends(i,j)>0)
%             if(i < izqX)
%                 izqX=i;
%                 izqY=j;
%             end
%             if (i > derX)
%                 derX=i;
%                 derY=j;
%             end
%             if (j < arrY)
%                 arrY=j;
%                 arrX=i;
%             end
%             if (j > abaY)
%                 abaY=j;
%                 abaX=i;
%             end
%         end
%     end
% end
%             
% disp('izq');
% disp([izqX,izqY]);
% disp('der');
% disp([derX,derY]);
% disp('arr');
% disp([arrX,arrY]);
% disp('aba');
% disp([abaX,abaY]);
% cte = 100;
% %izquierda
% cIzq = ends(izqX:izqX+cte*2,izqY-cte:izqY+cte);
% sIzq = sum(cIzq(:))
% %derecha
% cDer = ends(derX-cte*2:derX,derY-cte:derY+cte);
% sDer = sum(cDer(:))
% %arriba
% cArr = ends(arrX-cte:arrX+cte,arrY:arrY+cte*2);
% sArr = sum(cArr(:))
% %abajo
% cAba = ends(abaX-cte:abaX+cte,abaY-cte*2:abaY);
% sAba = sum(cAba(:))

%[r,m,b] = regression(fil,col);
% figure(5); plot(col,fil);
% text(izqX,izqY,'izq');
% text(derX,derY,'der');
% text(arrX,arrY,'arr');
% text(abaX,abaY,'aba');


%figure(5); imshow(puen); impixelinfo;
% % % % regions props
% e(l==d)=1;
% stats = regionprops(e, 'all');
% e(l==d)=255;
% o = stats.Orientation;
% pol = stats.Extrema;

% disp(pol);


% an = (1)*o;
% disp(an);
% a = imrotate(a,an);
% figure(4); imshow(B); impixelinfo;
% % cuad = stats.BoundingBox;
% % pen = (cuad(2)-cuad(4))/(cuad(1)-cuad(3));
% % i1 = cuad(2)-(pen*cuad(1));
% % i2 = cuad(4)-(pen*cuad(3));
% % disp(cuad)
% % disp('pend ');
% % disp(pen);
% % disp('1: ');
% % disp(i1);
% % disp(' 2: ');
% % disp(i2);


% % esque = bwmorph(c,'skel',Inf);
% % figure(4); imshow(esque); impixelinfo;
% procesar la imagen
 
            %subplot (handles.imagenprocesada),imshow(a);
% figure(1); imshow(b); impixelinfo
% contorno
% % % disp(pol)
% % % disp('hull')
% % % cH = stats.ConvexHull;
% % % [l, t] = size(cH);
% % % disp(size(cH))
% % % % disp(size(cH));
% % % x=[];
% % % y=[];
% % % for i=1:l
% % %     x = [x, cH(i,1)];
% % %     y = [y, cH(i,2)];
% % % end
% % % disp('x')
% % % disp(x)
% % % disp('y')
% % % disp(y)
% % % figure(1); plot(x,y);
% % % for i=1:l
% % %     text(x(i),y(i),['O',num2str(i)]);
% % % end
% % % figure(2); imshow(e); impixelinfo;



function longMax_Callback(hObject, eventdata, handles)
% hObject    handle to longMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of longMax as text
%        str2double(get(hObject,'String')) returns contents of longMax as a double


% --- Executes during object creation, after setting all properties.
function longMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to longMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function longMin_Callback(hObject, eventdata, handles)
% hObject    handle to longMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of longMin as text
%        str2double(get(hObject,'String')) returns contents of longMin as a double


% --- Executes during object creation, after setting all properties.
function longMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to longMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disTallo_Callback(hObject, eventdata, handles)
% hObject    handle to disTallo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disTallo as text
%        str2double(get(hObject,'String')) returns contents of disTallo as a double


% --- Executes during object creation, after setting all properties.
function disTallo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disTallo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
