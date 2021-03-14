clc;
close all;
clear;
tic
 
iptsetpref('ImshowAxesVisible','on');
img = imread('skewww.jpg');
figure; imshow(img);                          
gray=rgb2gray(img);
BW = imbinarize(gray);
E = edge(BW);
m1=0;
theta = 0:179;
[R, xp] = radon(E, theta);
[a,b] = size(R);
for i=1:a  
    for j=1:b  
        m=R(i,j);
        if(m>m1) 
            angle=j;
            m1=m;
        end
    end
end
    if(angle >= 90)  
        skewangle = -(angle - 91); 
    else
        skewangle = (91 - angle);
    end
      
    fprintf('Angle of Skew: %.3f\n',angle);
    fprintf('Skew Correction: %.3f\n', skewangle);
    
      imrot = imrotate(gray,skewangle);
      figure; hold on;
    imshow(imrot);
 
figure, hold on;
imshow(R,[],'XData',theta,'YData',xp,'InitialMagnification','fit')
xlabel('\theta(degrees)')
ylabel('x''')
colormap(gca,hot),colorbar

timeElapsed = toc;
fprintf('Execution time: %.3f\n',timeElapsed);
