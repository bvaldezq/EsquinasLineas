%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Implementación del algoritmo de Harris
%para la detección de esquinas en una imagen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%I=imread('Imagenes/figuras-planas.jpg');
I=imread('Imagenes/iglesia san geronimo.jpg');
%I=imread('Imagenes/Pirámide Chichen Itza-Yucatán.jpg');

Ir=rgb2gray(I);
%Se obiene el tamaño de la imagen. Ir a la cual se
%le extraerán las esquinas (PASO 1).
[m,n]=size(Ir);
%Se inicializan las matrices U y S con ceros
U=zeros(size(Ir));
S=zeros(size(Ir));
%Se crea la matriz de coeficientes del efiltro %suavizador
h=ones(3,3)/9;
%Se cambia el tipo de dato de la imagen original a %double
Id=double(Ir);
%Se filtra la imagen con el filtro h promedidor
If=imfilter(Id,h);
%Se generan las matrices de coeficientes para
%calcular el gradiente horizontal Hx y vertical Hy
Hx=[-0.5 0 0.5];
Hy=[-0.5;0;0.5];
%Se calculan los gradientes horizontal y vertical
Ix=imfilter(If,Hx);
Iy=imfilter(If,Hy);
%Se obtienen los coeficientes de la matriz de estructuras
HE11=Ix.*Ix;
HE22=Iy.*Iy;
HE12=Ix.*Iy; %y HE21
%Se crea la matriz del filtro gaussiano
Hg=[0 1 2 1 0; 1 3 5 3 1; 2 5 9 5 2 ; 1 3 5 3 1; 0 1 2 1 0];
Hg=Hg*(1/57);
%Se filtran los coeficientes de la matriz de estructuras
%con el fltro gaussiano
A=imfilter(HE11,Hg);
B=imfilter(HE22,Hg);
C=imfilter(HE12,Hg);
%Se fija el valor de alfa a 0.1 (SENSIBILIDAD media)

%A menor sensibilidad más esquinas encontradas
alfa=0.08;

%Se obtiene la magnitud del valor de la esquina
Rp=A+B; %Resultado parcial
Rp1=Rp.*Rp; %Resultado parcial
%Valor de la esquina (matriz Q)
Q=((A.*B)-(C.*C))-(alfa*Rp1);

%Se fija el valor del umbral
%A menor UMBRAL más esquinas detectadas (1000)
th=1000;

%Se obriene la matriz U (PASO 2).
U=Q>th;

%Se fija el valor de la vecindad (10)
pixel=5;

%Se obtiene el valor más grande de Q, de una vecindad
%definida por la variable pixel (PASO 3).
for r=1:m
    for c=1:n
        if(U(r,c))
            %Se define el límite izquierdo de la %vecindad
            I1=[r-pixel 1];
            %Se define el límite derecho de la vecindad
            I2=[r+pixel m];
            %Se define el límite superior de la vecindad
            I3=[c-pixel 1];
            %Se define el límite imferior de la vecindad
            I4=[c+pixel n];
            %Se definen posiciones teniendo en cuenta %que su valor es
            %relativo a r y c.
            datxi=max(I1);
            datxs=min(I2);
            datyi=max(I3);
            datys=min(I4);
            %Se extrae el bloque de la matriz Q
            Bloc=Q(datxi:1:datxs,datyi:1:datys);
            %Se obriene el valor máximo de la vacindad
            MaxB=max(max(Bloc));
            %Si el valor actual del pixel es el máximo
            %Entonces en esa posición se coloca un 1 en la matriz S.
            if(Q(r,c)==MaxB)
                S(r,c)=1;
            end
        end
    end
end
%Se despliega la imagen original
figure
imshow(I);
%Se mantiene el objeto gráfico para que lso demás 
%comandos gráficos tengan ejecto sobre la imagen Ir
%desplegada
hold on
%Se grafican sobre la imagen Ir las esquinas calculadas 5or el algoritmo de
%Harris en las posiciones donde %existen unsl en la matriazS
for r=1:m
    for c=1:n
        if(S(r,c))
            %Donde hay un uno se añade a la imagen Ir un %sibolo +
            plot(c,r,'*','MarkerSize',9);
        end
    end
end