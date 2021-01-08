%**************************************************************************
% tilt correction in 5 steps around X-axis and Y-axis
%**************************************************************************
%Step 1	Measure height points  
    %a.)along the x-axis from ~1.8 -> 3mm radius
    %b.)along the y-axis from ~1.8 -> 3mm radius, with negative only y
    %values (ie bottom half of the y-axis to avoid the large orfice, which
    %the picture is at the bottom but at this stage is at the top (gets
    %flipped later)
%Step 2 fit to a line of best fit (x-axis and y-axis_negative line)
%Step 3 calculate angle of tilt to push back to x-axis and back to y-axis
%Step 4	rotate around x-axis
%Step 5	rotate around y-axis

%the shape is slightly concave so line of best fit will not work
%choose 2 ponits along a line (say at 3000dia, as above this some

function [XX_t, YY_t, ZZ_t] = tilt_routine(XX, YY, ZZ, AA, RR)

Angs_t = [179.5 -0.5 89.75];
theta_rad =zeros(size(Angs_t));
theta_deg =zeros(size(Angs_t));
iAng=0;
ZZ_segm=cell(size(Angs_t));
RRs=cell(size(Angs_t));

for Ang_t = Angs_t
    iAng = iAng +1;
    %values along axis (x+ve, X-ve or Y) to use to detemrmine tilt
    idxAng_t = find(AA>Ang_t & AA<Ang_t+0.5 &RR<4500&RR>100 & ZZ<0); %ZZ<0 to ignore NaNs as ~=NaN wasn't working well
    [RRs{iAng} iSortCo2]=sort(RR(idxAng_t)); 
    ZZ_segm{iAng} =ZZ(idxAng_t(iSortCo2)); %USES the iSortCo2 to
    %sort the ZZ values from smallest RR to largest RR.
    p = polyfit(RRs{iAng},ZZ_segm{iAng},1); %fit a line p(1) = m, p(2) = c from y=mx+c
    theta_rad(iAng) = atan(p(1)); %in radians
    theta_deg(iAng) = atand(p(1)); %in degrees
end

XX_ut = XX;YY_ut = YY;ZZ_ut = ZZ;

a=5;