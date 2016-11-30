function [ d ] = normaliza( e )
e=double(e);
e=e/max(e(:))*255;
d=uint8(e);
end