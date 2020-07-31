%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Implementación del algoritmo de wang y Brady
%para la deteccion de esquinas en una imagen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Se carga la imagen a detectar las esquinas.
Iorig = imread('Imagenes/iglesia san geronimo.jpg');
%Se convierte en tipo de dato double para evitar
%problemas de cálculo
Im = double (rgb2gray(Iorig));
%Se define la matriz del prefiltro
h=ones(3)/9;
%Se filtra la imagen
Im = imfilter(Im,h);
%Se define el filtro descrito en la ecuación 8.31
d1=[0, -0.5, 0; -0.5, 0, 0.5; 0, 0.5, 0];
%Se define el filtro descrito en la ecuación 8.33
d2=[0, 1, 0; 1, -4, 1; 0, 1, 0];
%Se calculan las expresiones 8.31 y 8.3
I1 = imfilter(Im,d1);
I2 = imfilter(Im,d2);
%Se define el parámetro de sensibilidad
c = 4;
V = (I2-c*abs(I1));
%Se escala la imagen
V = (1000/max(max(V)))*V;
%Se binariza la imagen
V1=(V)>250;
%Se define la vecindad de búsqueda
pixel = 40;
%Se obtiene el valor más grande de V, de una vecindad
%definida por la variable pixel
[n,m] = size(V1);
res = zeros(n,m);
for r=1:n
    for c=1:m
        if(V1(r,c))
            I1=[r-pixel,1];
            I1=max(I1);
            I2=[r+pixel,n];
            I2=min(I2);
            I3=[c-pixel,1]
            I3=max(I3);
            I4=[c+pixel,m];
            I4=min(I4);
            
            tmp =V(I1:I2,I3:I4);
            maxim =max(max(tmp));
            if(maxim == V(r,c))
                res(r,c) =1;
            end
        end
    end
end
%Se grafican sobre la imagen Iorig las esquinas 
%calculadas por el algoritmo de Wng y Brady en las 
%posiciones dende existen unos en la matriz res
imshow(uint8(Iorig));
hold on
[re,co] = find(res');
plot(re,co,'+');
            