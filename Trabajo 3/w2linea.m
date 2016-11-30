function [ f ] = w2linea( g )
[fil,col,cap]=size(g);
f=reshape(g,[fil,col*cap]);
end

