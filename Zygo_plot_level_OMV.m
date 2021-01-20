% file = 'C:\Users\Documents\FT\OMV_20230002.dat';
file = 'C:\Data\DAF\Zygo Traces For Matlab\18490632-OMV.DAT';
[XX,YY,PP,ZygoConfig]=fnImportZygoPhaseHalf(file);

% re-adjust height

PP = PP - max(max(PP));

%re-adjust center of the plot 
X = reshape(XX,size(XX,1)*size(XX,2),1);
Y = reshape(YY,size(YY,1)*size(YY,2),1);

% find center.
[xc,yc] = circfit(X,Y);
clear X Y
XX = XX - xc;
YY = YY - yc;

COL = [0.8 0.8 0.8
    0.5 0.5 0.9
    0.0 0.0 1.0
    0.2 0.5 0.8
    0.0 1.0 1.0
    0.1 0.5 0.55
    0.0 1.0 0.0
    0.2 0.8 0.1
    0.5 0.67 0.19
    0.8 0.9 0.2
    1.0 1.0 0.0
    0.93 0.69 0.13
    0.8 0.5 0.1
    0.9 0.33 0.1
    1.0 0.0 0.0
    0.64 0.08 0.18
    0.0 0.0 0.0
    ];

figure(1)
p = pcolor(XX,YY,PP);set(p,'linestyle','none');hold all
caxis([-50 0]);h = colorbar;
colormap(COL);
set(gca,'layer','top');
set(gca,'xtick',-500:100:500);
set(gca,'ytick',-500:100:500);
grid on
title('original data');

%% levelling algorithm
% get a horizontal and vertical line pts of arbitraty thickness. ranging
% from 0 to 450mm radius within the face.
hor_pts = find(YY > -10 & YY < 10 & XX > -450 & XX < 450 & ~isnan(PP));  %add ~isnan(PP) to ignore the missing values
ver_pts = find(XX > -10 & XX < 10 & YY > 0 & YY < 450 & ~isnan(PP)); %only use half the y-line to avoid completely the orifice

PP_hor_pts = PP(hor_pts) %%PP (ZZ or height points) along the x line
PP_ver_pts = PP(ver_pts) %PP (ZZ or height points) along the y line 

XX_h = XX(hor_pts);YY_v = YY(ver_pts); %so the X values from the centre (+/-10microns)= XX_h 

%____________ADDED CODE_____________________________________________________
x_line = unique(XX_h); % unique x values
y_line = unique(YY_v); % unique x values

PP_m_x = zeros(size(x_line)); % matrix for the median (ZZ values) for each unique X value 
PP_m_y = zeros(size(y_line)); % matrix for the median (ZZ values) for each unique Y value 

for it = 1 : size (PP_m_x,1)% for each unique value of X on the x-line, find the median of the ZZ points
	PP_x = find(XX_h > x_line(it)-0.5 & XX_h < x_line(it)+0.5);	%0.5 as values are not exactly 0 (stored as doubles), to avoid errors
    PP_m_x(it) = median(PP_hor_pts(PP_x));
end

for it = 1 : size (PP_m_y,1)%similar to above but for y-line
    PP_y = find(YY_v > y_line(it)-0.5 & YY_v < y_line(it)+0.5);	%z_u2 finds the locations in the XX_h array where the above is true
    PP_m_y(it) = median(PP_ver_pts(PP_y));
end

%_________________________________________________________________________

% now fit a line
px = polyfit([x_line(1) x_line(end)],[PP_m_x(1) PP_m_x(end)],1);
py = polyfit([0 y_line(end)],[px(2) PP_m_y(end)],1);

% re-adjust the PP data. using this. similar to  fitting a plane
PP1 = PP;
% re-adjust the horizontal axis
PP1 = PP1 - (XX*px(1) + px(2));
% re-adjust the vertical axis
PP1 = PP1 - (YY*py(1) + py(2));
%%
% find level of the mid face

[TT,RR] = pol2cart(XX,YY);
face_pts = find(RR > 0 & RR < 450);

face_level = median(median(PP1(face_pts(~isnan(PP1(face_pts))))));

figure(2)
% p1 = pcolor(XX,YY,PP1-max(max(PP1)));set(p1,'linestyle','none');
p1 = pcolor(XX,YY,PP1-face_level);set(p1,'linestyle','none');
caxis([-50 0]);h = colorbar;
colormap(COL);
set(gca,'layer','top');
set(gca,'xtick',-500:100:500);
set(gca,'ytick',-500:100:500);
grid on
h1 = colorbar;
title('re-levelled')
