function [b,c,l,h] = componentes_color(a)
[fil,col,cap]=size(a);
if cap==1
    b=a;
    c=a;
    return
end
%%componentes rgb
a1=a;
a1=normaliza(a1);
c=a1(:,:,3);  %sacamos componente Y que es la mejor
a1=w2linea(a1);
%%componentes hsv
a2=rgb2hsv(a);
s=a2(:,:,2); s=normaliza(s);
a2=normaliza(a2);
h = a2(:,:,2);
a2=w2linea(a2);
%componentes lab
cform=makecform('srgb2lab');
a3=applycform(a,cform);
a3=normaliza(a3);
l=a3(:,:,3);
a3=w2linea(a3);
%componentes cmyk
cform=makecform('srgb2cmyk');
a4=applycform(a,cform);
a4=normaliza(a4);
k=a4(:,:,4);
a4=a4(:,:,1:3); %mostrar solo las primeras 3 filas
c = a4(:,:,3);
a4=w2linea(a4);
%%
b=[a1;a2;a3;a4];

end
