%**************************************************************************
% levelling aglorithm
%**************************************************************************

function [XX, YY, ZZ] = tilt_routine(XX, YY, ZZ)

hor_pts = find(YY > -100 & YY < 100 & XX > -4800 & XX < 4800 & ~isnan(ZZ));  %add ~isnan(ZZ) to ignore the missing values
ver_pts = find(XX > -100 & XX < 100 & YY > 0 & YY < 4800 & ~isnan(ZZ)); %only use half the y-line to avoid completely the orifice

ZZ_hor_pts = ZZ(hor_pts); %%ZZ (height points) along the x line
ZZ_ver_pts = ZZ(ver_pts); %ZZ (height points) along the y line 

XX_h = XX(hor_pts);YY_v = YY(ver_pts); %so the X values from the centre (+/-10microns)= XX_h 

x_line = unique(XX_h); % unique x values
y_line = unique(YY_v); % unique x values

ZZ_m_x = zeros(size(x_line)); % matrix for the median (ZZ values) for each unique X value 
ZZ_m_y = zeros(size(y_line)); % matrix for the median (ZZ values) for each unique Y value 

for it = 1 : size (ZZ_m_x,1)% for each unique value of X on the x-line, find the median of the ZZ points
    ZZ_x = find(XX_h > x_line(it)-0.5 & XX_h < x_line(it)+0.5);	%0.5 as values are not exactly 0 (stored as doubles), to avoid errors
    ZZ_m_x(it) = median(ZZ_hor_pts(ZZ_x));
end

for it = 1 : size (ZZ_m_y,1)%similar to above but for y-line
    ZZ_y = find(YY_v > y_line(it)-0.5 & YY_v < y_line(it)+0.5);	%z_u2 finds the locations in the XX_h array where the above is true
    ZZ_m_y(it) = median(ZZ_ver_pts(ZZ_y));end

%_________________________now fit a line________________________________________________
px = polyfit([x_line(1) x_line(end)],[ZZ_m_x(1) ZZ_m_x(end)],1);
py = polyfit([0 y_line(end)],[0 ZZ_m_y(end)-px(2)],1); %if the x-line correction is done 1st, then y is copmared to that hence the px(2) and the 0's for the centre of the plane

% re-adjust the ZZ data. using this. similar to  fitting a plane
ZZX = ZZ - (XX*px(1) + px(2)); %xx corection only
ZZY = ZZ - (YY*py(1) + py(2)); %yy corection only

% re-adjust the horizontal axis
ZZ = ZZ - (XX*px(1) + px(2));  %xx corection (and height)

% re-adjust the vertical axis
ZZ = ZZ - (YY*py(1) + py(2));  %yy correction (after xx, height correction)