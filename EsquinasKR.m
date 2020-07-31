%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Implementación del algoritmo de Kitchen y Rsenfeld
%para la detección de esquinas en una imagen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Se carga la imagen a detectar las esquinas.
Iorig = imread('Imagenes/KircheAmSudsternKreuzberg.jpg');
%Se confierte a tipo de dato double para evitar
%problemas de cálculo
Im = double (rgb2gray(Iorig));
%Se define la matriz del profiltro
h=ones(3)/9;
%Se filtra la imagen
Im = imfilter(Im,h);
%Se definen los filtros Sobel
sx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
sy = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
%Se obtiene la primera derivada parcial
Ix = imfilter(Im,sx);
Iy = imfilter(Im,sy);
%Se obtiene la segunda derivada parcial
Ixx = imfilter(Ix,sx);
Iyy=imfilter(Iy,sy);
Ixy=imfilter(Ix,sy);
%Se calcula el numerador de la ecuacion 7.27
A = (Ixx.*(Iy.^2)) + ( Iyy.*(Ix.^2))- (2*Ixy.*Iy);
%Se calcula el denominador de la ecuación 7.27
B = (Ix.^2) + (Iy.^2);
%Se calcula la ecuación 7.27
V= (A./B);
%Se escaala la imagen
V=(1000/max(max(V)))*V;
%Se binariza la imagen
V1 = (V)>40;
%Se define la vecindad de búsqueda
pixel =10;
%Se obtiene el valor más grande de V, de una vecindad
%definida por la variable pixel
[n,m] = size(V1);
res = zeros(n,m);
for r=1:n %rows
    for c=1:m %cols
        if(V1(r,c))
            I1=[r-pixel,1];
            I1=max(I1);
            I2=[r+pixel,n];
            I2=min(I2);
            I3=[c-pixel,1];
            I3=max(I3);
            I4=[c+pixel,m];
            I4=min(I4);
            
            tmp = V(I1:I2,I3:I4);
            maxim = max(max(tmp));
            if(maxim == V(r,c))
                res(r,c) = 1;
            end
        end
    end
end
%Se grafican sobre la imagen Iorig las esquinas 
%calculadas por el algoritmo de Kitchen y Rosenfels 
%en las posiciones donde existen unos en la matriz res

imshow(uint8(Iorig));
hold on
[re,co] = find(res');
plot(re,co,'+');