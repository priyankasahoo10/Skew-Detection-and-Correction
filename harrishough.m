clear;
close all;
clc
tic
 
img = imread('photo2.jpg');
gray = rgb2gray(img); %converting RGB to gray
corners = detectHarrisFeatures(gray); %find corners
figure, imshow(gray); hold on; 
plot(corners.selectStrongest(50));%display corner points
BW = edge(gray,'canny'); %extract edge using canny detector
figure, imshow(BW); 
[H,theta,rho] = hough(BW); %calculate hough transform
imshow(BW);
figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot) %display hough matrix
 
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:)))); %lines 23 - 27: finding peaks in the hough transform of the image
 
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7); %finding houghline
figure, imshow(gray), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
 
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
 
   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
 
angle = lines.theta; %angle of orientation
 
if (angle >= -0)
    skewangle = (angle - 90);
else
    skewangle = 90 + angle;
end
 
imrot = imrotate(gray, skewangle);
figure; imshow(imrot), hold on;
 
fprintf('Angle of skew is %.3f\n',angle);
fprintf('Angle of skew Correction: %.3f\n',skewangle);

timeElapsed = toc;
fprintf('Execution time is %.3f\n',timeElapsed);
