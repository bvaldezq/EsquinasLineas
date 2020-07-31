%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Implementación del algoritmo de Beaudet
%para la detección de esquinas en una imagen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Se carga la imagen para detectar las esquinas.
Iorig=imread('Imagenes/Pirámide Chichen Itza-Yucatán.jpg');
%Se convierte a tipo de dato double para evitar problemas de calculo
Im=double(rgb2gray(Iorig));
%Se define la matriz del prefiltro
h=ones(3)/9;
%Se filtra la imagen
Im=imfilter(Im,h);
%Se definen los filtros Sobel
sx=[-1, 0, 1; -2, 0, 2; -1, 0, 1];
sy=[-1, -2, -1; 0, 0, 0; 1, 2, 1];
%Se obriene la primera derivada parcial
Ix = imfilter(Im,sx);
Iy = imfilter(Im,sy);

%Se obtiene la segunda derivada parcial
Ixx = imfilter(Ix,sx);
Iyy = imfilter(Iy,sy);
Ixy = imfilter(Ix,sy);
%Se calcula el denominador de 8.25
B = (1 +Ix.* Ix + Iy.* Iy) .^2;
%Se obtiene el determinante definido en 8.24
A = Ixx.*Iyy - (Ixy).^2;
%Se calula el valor de B(x,y) de 8.25
B = (A./B);
%Se escala la imagen
B = ( 1000/max(max(B)))*B;
%Se binariza la imagen
V1= (B)>80;
%Se define la vecindad de búsqueda
pixel = 80;
%Se obiene el valor más grande de B, de una vecindad
%definida por la variable pixel
[n,m] = size(V1);
res = zeros(n,m);
for r=1:n
    for c=1:m
        if (V1(r,c))
            I1=[r-pixel,1];
            I1 =max(I1);
            I2=[r+pixel,n];
            I2=min(I2);
            I3=[c-pixel,1];
            I3=max(I3);
            I4=[c+pixel,m];
            I4=min(I4);
            
            tmp=B(I1:I2,I3:I4);
            maxim = max(max(tmp));
            if(maxim == B(r,c))
                res(r,c) = 1;
            end
        end
    end
end

%se grafican sobre la imagen Iorig las esquinas %caluladas
%por el algoritmo de Beaudet en las %posiciones donde existen
%unos en la matriz res

imshow(uint8(Iorig));
hold on
[re,co] = find(res');
plot(re,co,'+');