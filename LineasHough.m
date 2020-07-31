%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Programa que implementa la transformada de Hough
% usada para la detección de Líneas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%Se lee la imagen con la que se trabajará y convierte a escala de grises.

I=imread('Imagenes/figuras-planas.jpg');
%I=imread('Imagenes/iglesia san geronimo.jpg');
%I=imread('Imagenes/Pirámide Chichen Itza-Yucatán.jpg');

I1=rgb2gray(I);
%Se obtienen los bordes de la imagen. utilizando el método Sobel.



BW=edge (I1, 'Canny');
BW=I1<60;
figure, imshow(BW);
%Se obtienen las dimensiones de la imagen binaria 
%donde los pixeles que tienen el valor uno son 
%parte del borde, mientras que cero significaría
%que son parte del fondo.
[m,n]=size(BW);
%PARTE 1 (Se obtiene MRAcc).
%Se inicializan algunas matrices que participan 
%en el procesamiento.
%Se inicializa la matriz de registros de acumulación 
MRAcc=zeros(m,n);
%Se inicializa la matriz donde se almacenan los 
% máximos locales obtenidos.
Fin=zeros(m,n);
%Se define como referencia de coordenadas 
%el centro de la imagen.
m2=m/2;
n2=n/2;
%Se calcula el valor máximo de r , dependiendo
%de las dimensiones de la imagen (véase ecuación 8.9).
rmax=round(sqrt(m2*m2+n2*n2));
%Se obtiene el escalamiento lineal de los
%parámetros de Hough. tetha y r
iA=pi/n;
ir=(2*rmax)/m;


%Se recorre la imagen BW poniendo atención en los puntos bordes donde BW es uno.

for re=1:m
    for co=1:n
        if(BW(re,co))
            for an=1:n
                %Se considera como referencia
                %el centro de La imagen.
                x=co-n2; 
                y=re-m2; 
                theta=an*iA;
                %Se obtiene el valor de r a partir de 9.6. 
                r=round(((x*cos(theta)+y*sin(theta))/ir)+m2); 
                if((r>=0)&&(r<=m))
                    %Se incrementa  en uno La celda
                    %correspondiente a los parámetros r y theta. 
                    MRAcc(r,an)= MRAcc(r,an)+1;
                end
            end
        end
    end
end
%PARTE 2 (Se selecciona el registro máximo localmente). 
%Se le segmentan 1os pixeles de MRAcc, aplicando
%como umbral (th) 100. De esta manera, los pixeles de 
%Bandera que sean uno representarán a aquellos
%r egistros que constituyen 1íneas formadas de
%al menos 100 puntos.
Bandera=MRAcc>80;



%Se muestra la imagen tras aplicarle el umbral determinado 
figure, imshow(Bandera)
%Se establece para la búsqueda del máximo
%una vecindad de 10 pixeles. 
pixel=10;
%Se barre la i magen en busca de los puntos
%potenciales.
for re=1:m
    for co=1:n
        if (Bandera(re,co))
            %Se establece en la región de vecindad
            %de búsqueda. 
            I1=[re-pixel 1]; 
            I2=[re+pixel m]; 
            I3=[co-pixel 1]; 
            I4=[co+pixel n]; 
            datxi=max(I1); 
            datxs=min(I2); 
            datyi=max(I3); 
            datys=min(I4);
            Bloc=MRAcc(datxi:1:datxs,datyi:1:datys); 
            MaxB=max(max(Bloc));
            %Se selecciona el pixel de valor máximo contenido 
            %en esa vecindad.
            if(MRAcc(re,co)>=MaxB)
                %El pixel de valor máximo es 
                %marcado en la matriz Fin. 
                Fin(re,co)=255;
            end
        end
    end 
end
%Se obtienen las coordenadas de los píxeles
%cuyo valor fue el máximo que representará a
%los registros. los cuales sus índices representan
%a los parámetros de las líneas detectadas.
[dx,dy]=find(Fin);
%PARTE 3 (Las líneas enconlradas se desrliegan).
%Se obtiene en indx el número de líneas detectadas
%que implica el número de el ementos de Fin.
[indx,nada]=size (dx);
rm=m;
cn=n;
apunta=1;
%Se inicializa a cero la matriz M donde se desplegarán
%las líneas encontradas.
M=zeros(rm,cn) ;
%Se despliegan todas las líneas encontradas.
for dat=1:indx
%Se recuperan  I os val or es de I os par ámet r os de
%I as I íneas encont r adas.
pr=dx(dat); 
pa=dy(dat); 
%Se considera que los valores de los parámetros
%se definen considerando el centro de la imagen.
re2=round (rm/2);



co2=round(cn/2);
%Se escalan los valores de r y theta.
pvr=(pr-re2)*ir;
pva=pa*(pi/cn);
%Se obtienen las proyecciones verticales y
%horizontales de r, ya que r es el vector definido
%en el origen y perpendicular a la línea detectada. 
x=round(pvr*cos(pva));
y=round(pvr*sin(pva));
%Se elimina el offset.consi derado por utilizar como
%referencia el centro de la imagen.
Ptx(apunta)=x+co2; 
Pty(apunta)=y+re2; 
%Se incrementa el índice considerado para
%apuntar los parámetros encontrados que definen
%el número de líneas. 
apunta=apunta+1;
%Se barre el modelo de recta  con los parámetros
%detectados y almacenados en la matriz de registros
%acumuladores.
%Primero en un sentido. 
for c=x:1:co2
    r=round((-1*(x/y)*c)+y+(x*x/y))+re2;
    if((r>0)&&(r<rm)) 
        M(r,c+co2)=1; 
    end
end
MRAcc=mat2gray(MRAcc);



%después en el sentido no considerado.
for c=x:-1:1-co2
    r=round((-1*(x/y)*c)+y+(x*x/y))+re2;
    if((r>0) && (r<rm) ) 
        M(r,c+co2)=1; 
    end
end
end
%Se muestra 1a matriz de registros de acumulación
figure, imshow(MRAcc)
%despliegue de 1as 1íneas encontradas
figure, imshow(M)
