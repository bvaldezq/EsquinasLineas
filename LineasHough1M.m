%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programa que despliega las líneas calculadas por las funciones hough,
%houghpeaks, houghlines sobre BW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

%I=imread('Imagenes/figuras-planas.jpg');
%I=imread('Imagenes/iglesia san geronimo.jpg');
%I=imread('Imagenes/Pirámide Chichen Itza-Yucatán.jpg');
I=imread('Imagenes/mitad del mundo-ecuador.jpg');


I1=rgb2gray(I);
BW=edge(I1,'canny',0.1,0.1);
[H, theta, rho]=hough(BW);  
Hu=uint8(H);
imshow(Hu,[],'XData',theta,'YData',rho,'InitialMagnification','fit')

axis on, axis normal

P=houghpeaks(H,20,'threshold',ceil(0.3*max(H(:))));
%P=houghpeaks(H,150,'threshold',ceil(0.1*max(H(:))));

hold on

x=theta(P(:,2));
y=rho(P(:,1));
plot(x,y,'s');
lines=houghlines(BW,theta,rho,P);
figure
imshow(BW);

hold on
max_len = 0;
%se barren los arreglos de estructuras encontradas lineas
%que contienen los valores de las lineas
for k=1:length(lines)
xy = [lines(k).point1; lines(k).point2];
plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%Se grafica el inicio y final de las lineas
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%Se determina el final del segmento mas largo
len = norm(lines(k).point1 - lines(k).point2);
if(len>max_len)
	max_len = len;
xy_long = xy;
end
end
%Se resalta los segmentos largos
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');


figure,imshow(I);
