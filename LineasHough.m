%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Programa que implementa la transformada de Hough
% usada para la detecci�n de L�neas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%Se lee la imagen con la que se trabajar� y convierte a escala de grises.

I=imread('Imagenes/figuras-planas.jpg');
%I=imread('Imagenes/iglesia san geronimo.jpg');
%I=imread('Imagenes/Pir�mide Chichen Itza-Yucat�n.jpg');

I1=rgb2gray(I);
%Se obtienen los bordes de la imagen. utilizando el m�todo Sobel.



BW=edge (I1, 'Canny');
BW=I1<60;
figure, imshow(BW);
%Se obtienen las dimensiones de la imagen binaria 
%donde los pixeles que tienen el valor uno son 
%parte del borde, mientras que cero significar�a
%que son parte del fondo.
[m,n]=size(BW);
%PARTE 1 (Se obtiene MRAcc).
%Se inicializan algunas matrices que participan 
%en el procesamiento.
%Se inicializa la matriz de registros de acumulaci�n 
MRAcc=zeros(m,n);
%Se inicializa la matriz donde se almacenan los 
% m�ximos locales obtenidos.
Fin=zeros(m,n);
%Se define como referencia de coordenadas 
%el centro de la imagen.
m2=m/2;
n2=n/2;
%Se calcula el valor m�ximo de r , dependiendo
%de las dimensiones de la imagen (v�ase ecuaci�n 8.9).
rmax=round(sqrt(m2*m2+n2*n2));
%Se obtiene el escalamiento lineal de los
%par�metros de Hough. tetha y r
iA=pi/n;
ir=(2*rmax)/m;


%Se recorre la imagen BW poniendo atenci�n en los puntos bordes donde BW es uno.

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
                    %correspondiente a los par�metros r y theta. 
                    MRAcc(r,an)= MRAcc(r,an)+1;
                end
            end
        end
    end
end
%PARTE 2 (Se selecciona el registro m�ximo localmente). 
%Se le segmentan 1os pixeles de MRAcc, aplicando
%como umbral (th) 100. De esta manera, los pixeles de 
%Bandera que sean uno representar�n a aquellos
%r egistros que constituyen 1�neas formadas de
%al menos 100 puntos.
Bandera=MRAcc>80;



%Se muestra la imagen tras aplicarle el umbral determinado 
figure, imshow(Bandera)
%Se establece para la b�squeda del m�ximo
%una vecindad de 10 pixeles. 
pixel=10;
%Se barre la i magen en busca de los puntos
%potenciales.
for re=1:m
    for co=1:n
        if (Bandera(re,co))
            %Se establece en la regi�n de vecindad
            %de b�squeda. 
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
            %Se selecciona el pixel de valor m�ximo contenido 
            %en esa vecindad.
            if(MRAcc(re,co)>=MaxB)
                %El pixel de valor m�ximo es 
                %marcado en la matriz Fin. 
                Fin(re,co)=255;
            end
        end
    end 
end
%Se obtienen las coordenadas de los p�xeles
%cuyo valor fue el m�ximo que representar� a
%los registros. los cuales sus �ndices representan
%a los par�metros de las l�neas detectadas.
[dx,dy]=find(Fin);
%PARTE 3 (Las l�neas enconlradas se desrliegan).
%Se obtiene en indx el n�mero de l�neas detectadas
%que implica el n�mero de el ementos de Fin.
[indx,nada]=size (dx);
rm=m;
cn=n;
apunta=1;
%Se inicializa a cero la matriz M donde se desplegar�n
%las l�neas encontradas.
M=zeros(rm,cn) ;
%Se despliegan todas las l�neas encontradas.
for dat=1:indx
%Se recuperan  I os val or es de I os par �met r os de
%I as I �neas encont r adas.
pr=dx(dat); 
pa=dy(dat); 
%Se considera que los valores de los par�metros
%se definen considerando el centro de la imagen.
re2=round (rm/2);



co2=round(cn/2);
%Se escalan los valores de r y theta.
pvr=(pr-re2)*ir;
pva=pa*(pi/cn);
%Se obtienen las proyecciones verticales y
%horizontales de r, ya que r es el vector definido
%en el origen y perpendicular a la l�nea detectada. 
x=round(pvr*cos(pva));
y=round(pvr*sin(pva));
%Se elimina el offset.consi derado por utilizar como
%referencia el centro de la imagen.
Ptx(apunta)=x+co2; 
Pty(apunta)=y+re2; 
%Se incrementa el �ndice considerado para
%apuntar los par�metros encontrados que definen
%el n�mero de l�neas. 
apunta=apunta+1;
%Se barre el modelo de recta  con los par�metros
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



%despu�s en el sentido no considerado.
for c=x:-1:1-co2
    r=round((-1*(x/y)*c)+y+(x*x/y))+re2;
    if((r>0) && (r<rm) ) 
        M(r,c+co2)=1; 
    end
end
end
%Se muestra 1a matriz de registros de acumulaci�n
figure, imshow(MRAcc)
%despliegue de 1as 1�neas encontradas
figure, imshow(M)
