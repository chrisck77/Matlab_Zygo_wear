
%***********************************************************
% Standalone routine to show tilt correction/height adjustment in operation
% Generate contour plots showing steps for each tilt corrected trace
% Also simple plots showing trace along x-axis and tilt correction
%***********************************************************

clear h

MSTRtype=1;
iSeatAng=0;
seat0pt=0;


if exist('iDesLev')==0;
	     iDesLev=menu('Choose Data Folder',{,'User Folder','Cancel'});
        if iDesLev==0 || iDesLev==3; return; end;
end;

if iDesLev==1;
[Root] = uigetdir('C:\Data\DAF\','Select data folder'); 
else if iDesLev==2;
[Root] = uigetdir('C:\Data\DAF\','Select data folder');
end;
end;


Root = [Root '\'];

tests=ls(fullfile(Root,'*.dat'));
kj =1;
i2=0;
i3=0;
leg_comb = strings(6,1);

for i=1:size(tests)

test2=tests(i,:);
fnmLift2=[Root test2];

%__________________pltflag='init';axJointOMV_new;__________________________________________
str2 = test2;
str_trim2 = str2(1:strfind(str2,'.')-1);
Title2 = str_trim2; 
g2=1;
if g2 == 2;
	f1=figure(1);

	ddsfigOMV;delete(ax(1));
	set(gcf,'windowbuttondownfcn','DDSzoomfig(gco,HkeyAX);');
    
    set(gcf,'papersize', [10 10]);            %A4 
    set(gcf,'paperposition',[1.83 2.99 15 15]);        %15 26 size to suit space in powerpoint frame  (26cm wide 15cm high
    screen=get(0,'screensize');                       %get users screen size
    set(gcf,'position',[50/1024*screen(3) 150/768*screen(4) 400/1024*screen(3) 540/768*screen(4)]); %set fig according to screen & paper size
    % change 15 15 to 15 25, 275/1024 to 400/1024

    defaultBackground = get(0,'defaultUicontrolBackgroundColor');
	set(gcf,'Color',defaultBackground);
	cm=[    0.7000    0.7000    0.7000
		0.3500    0.3500    0.7500
		0         0    0.8000
		0    0.6000    1.0000
		0    1.0000    1.0000
		0    0.5000    0.5000
		0    1.0000         0
		0.3000    0.8500         0
		0.6000    0.7000         0
		0.8000    0.8500         0
		1.0000    1.0000         0
		1.0000    0.6000         0
		0.8000    0.4000         0
		0.9000    0.2000         0
		1.0000         0         0
		0.5000         0         0
		0         0         0];
	colormap(cm);
	PlotColor=[0 0 1;1 0 0;0 1 0;0 0 0;1 0 1;0 1 1;1 1 0;0.8 0.8 0.8];
	PlotColor1=[0 0 1;0.8 0.8 0.8;1 1 0;0 1 1;1 0 1;0 0 0;0 1 0;1 0 0];

	ax(8)=axes;hold on;grid on;
	ax(5)=axes;hold on;grid on;
    ax(7)=axes;hold on;grid on;
    ax(9)=axes;hold on;grid on;
end;

	str2 = test2;
	str_trim2 = str2(1:strfind(str2,'.')-1);
	Title2 = str_trim2;  

if g2 == 2;
	%**************************************************************************
	% Axis 5 - Zygo OMV seat after tilt correction
	%**************************************************************************
	axes(ax(5));
	axis([-7000 7000 -7000 7000]);%was 3500
	axis square;
	set(ax(5),'units','normalized','pos',[0.06 -0.045 .45 .45]); % was .55 .55
	set(gca,'layer','top','xtick',-7000:800:7000,'ytick',-7000:800:7000,'xticklabel',[],'yticklabel',[]); %ws 3500:400:3500
	setappdata(gcf,'XlabDiv','100µm per div');
	title(sprintf('OMV tilt corrected %s', Title2),'Interpreter','none');
	
	%**************************************************************************
	% Axis 8 - Zygo OMV seat before tilt correction
	%**************************************************************************
	axes(ax(8));
	axis([-7000 7000 -7000 7000]);%was 3500
	axis square;
	set(ax(8),'units','normalized','pos',[0.06 0.45 .45 .45]);
	set(gca,'layer','top','xtick',-7000:800:7000,'ytick',-7000:800:7000,'xticklabel',[],'yticklabel',[]); %was 3500:400:3500
	setappdata(gcf,'XlabDiv','100µm per div');
	title(sprintf('OMV raw %s', Title2),'Interpreter','none');
    
    	%**************************************************************************
	% Axis 7 - XX tilt only
	%**************************************************************************
	axes(ax(7));
	axis([-7000 7000 -7000 7000]);%was 3500
	axis square;
	set(ax(7),'units','normalized','pos',[0.52 -0.045 .45 .45]);
	set(gca,'layer','top','xtick',-7000:800:7000,'ytick',-7000:800:7000,'xticklabel',[],'yticklabel',[]); %ws 3500:400:3500
	setappdata(gcf,'XlabDiv','100µm per div');
	title(sprintf('X tilt correction %s', Title2),'Interpreter','none');
	
	%**************************************************************************
	% Axis 9 - YY tilt only
	%**************************************************************************
	axes(ax(9));
	axis([-7000 7000 -7000 7000]);%was 3500
	axis square;
	set(ax(9),'units','normalized','pos',[0.52 0.45 .45 .45]);
	set(gca,'layer','top','xtick',-7000:800:7000,'ytick',-7000:800:7000,'xticklabel',[],'yticklabel',[]); %was 3500:400:3500
	setappdata(gcf,'XlabDiv','100µm per div');
	title(sprintf('Y tilt correction %s', Title2),'Interpreter','none');
end
%______________________________________________________________________________________________
%__________________________andOMV2 with tilt correction added____________________________________________________________________

	%**************************************************************************
	% Read height data
	% note YY and XX reversed to orientate data as on drawing
	%**************************************************************************
	[XX YY ZZ Conf]=fnImportZygoPhaseHalf(fnmLift2); %m-file to interpret .dat file 

	nrows=size(ZZ,1);nclms=size(ZZ,2);
	pixels_ratio = (XX(end,end)+1)/ nclms;
	%**************************************************************************
	% Calibrate the X and Y directions
	%**************************************************************************
	XX=(XX-1)*(Conf.CameraRes*1e6); %CameraRes in is m/pixel x 1000 to convert from m to microns
	YY=(YY-1)*(Conf.CameraRes*1e6); 
	%**************************************************************************
	% Give a rough center
	%**************************************************************************
	% XX=XX-(nclms-68)*Conf.CameraRes*1e6; %to use with C2 revised lift mask 14/01/2013 %% -68 %%
	% YY=YY-(nrows+10)*Conf.CameraRes*1e6; %% +10 %%
	XX=XX - (XX(end,end)/2); %centre cordinates 
	YY=YY - (YY(end,end)/2); 
	%**************************************************************************
	% convert to polar coordinates
	%**************************************************************************
	[AA RR]=cart2pol(XX,YY); AA=AA*180/pi;
	%**************************************************************************
	% find pin points
	%**************************************************************************
	idxPin=find(ZZ<85);
	%**************************************************************************
	% create vectors of pin which work faster in the angle finding loop below
	%**************************************************************************
	[AA RR]=cart2pol(XX,YY); AA=AA*180/pi; % Convert to polar cordinates :)

	Apin=AA(idxPin); %5 lines to remove values where Z >=85 and not correct 
	Rpin=RR(idxPin);
	Zpin=ZZ(idxPin);
	Xpin=XX(idxPin);
	Ypin=YY(idxPin);

	iAng=0;
	Angs=-180:0.5:179.5;  % Angle vector sets increments in which to look for max lift
	%     Angs=90.5:-0.5:-270.5;
	%pre-define variables
	AngsPlot=zeros(size(Angs));
	Zmax=zeros(size(Angs));
	XofMax=zeros(size(Angs));
	YofMax=zeros(size(Angs));

	%**************************************************************************
	% baseline unworn area to 0 for height --> loop round Angs looking for max lift along radii within an angle range
	%**************************************************************************

	for Ang=Angs; %loop through all chosen °
		% limit to radii between 800 and 1100 (for 2mm pin) - Rpin variable
	   idxAng=find(Apin>Ang&Apin<Ang+0.5&Rpin<3000&Rpin>1800&Zpin<-16);
		if ~isempty(idxAng); %did the above find contain any valid points?
			iAng=iAng+1; %step counter for loop
			AngsPlot(iAng)=Ang; 
			[Zmax(iAng) iMax]=max(Zpin(idxAng));  % max at this angle should be the seat height
			XofMax(iAng)=Xpin(idxAng(iMax));  % position of max in X and Y
			YofMax(iAng)=Ypin(idxAng(iMax));
		end
	end

	Lift=round((-1*median(Zmax)*10))/10; %from each angle slice, find the median seat height
	ZZ=ZZ+Lift; %Zero on seat

	%**************************************************************************
	% levelling aglorithm
	%**************************************************************************
	% get a horizontal and vertical line pts of arbitraty thickness. ranging
	% from 0 to 450mm radius within the face.
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
	ZZ1 = ZZ;
    
	ZZX = ZZ1 - (XX*px(1) + px(2)); %xx corection only
    ZZY = ZZ1 - (YY*py(1) + py(2)); %yy corection only
    
    % re-adjust the horizontal axis
	ZZ1 = ZZ1 - (XX*px(1) + px(2));
    
	% re-adjust the vertical axis
	ZZ1 = ZZ1 - (YY*py(1) + py(2));    

if g2 == 2;
	%**************************************************************************
	% Plotting main data - before tilt correction
	%**************************************************************************
    axes(ax(8));
    hold on;
    resolution=1;
    h(2)=pcolor(XX(1:resolution:end,1:resolution:end),YY(1:resolution:end,1:resolution:end),ZZ(1:resolution:end,1:resolution:end));
    set(h(2),'EdgeColor','none');
    caxis([-50 1]);hBar=colorbar; %caxis([-50 1]);hBar=colorbar;
    set(hBar,'ytick',-50:5:1);    %set(hBar,'ytick',-50:5:20);
	%**************************************************************************
	% Plotting main data - after tilt correction
	%**************************************************************************
    axes(ax(5));
    hold on;
    resolution=1;
    h(2)=pcolor(XX(1:resolution:end,1:resolution:end),YY(1:resolution:end,1:resolution:end),ZZ1(1:resolution:end,1:resolution:end));
    set(h(2),'EdgeColor','none');
    caxis([-50 1]);hBar=colorbar;   %caxis([-50 1]);hBar=colorbar;
    set(hBar,'ytick',-50:5:1);      %set(hBar,'ytick',-50:5:1);
    %**************************************************************************
	% after XX only
	%**************************************************************************
    axes(ax(7));
    hold on;
    resolution=1;
    h(2)=pcolor(XX(1:resolution:end,1:resolution:end),YY(1:resolution:end,1:resolution:end),ZZX(1:resolution:end,1:resolution:end));
    set(h(2),'EdgeColor','none');
    caxis([-50 1]);hBar=colorbar;   %caxis([-50 1]);hBar=colorbar;
    set(hBar,'ytick',-50:5:1);      %set(hBar,'ytick',-50:5:1);
    %**************************************************************************
	% after YY only
	%**************************************************************************
    axes(ax(9));
    hold on;
    resolution=1;
    h(2)=pcolor(XX(1:resolution:end,1:resolution:end),YY(1:resolution:end,1:resolution:end),ZZY(1:resolution:end,1:resolution:end));
    set(h(2),'EdgeColor','none');
    caxis([-50 1]);hBar=colorbar;   %caxis([-50 1]);hBar=colorbar;
    set(hBar,'ytick',-50:5:1);      %set(hBar,'ytick',-50:5:1);
    %****************************************************

str_trim1_1 = str_trim2(1:8); % extract pump number from file, anything before '-'
fname= [Root 'Output\'];

set(gcf,'PaperOrientation','portrait');
saveas(gca, [fname Title2 '.png']);
end;

%**************************************************************************
% graphs showing traces along x-line before and after tilt
%************************************************************************** 
if g2 == 2;
    figure(2)

    subplot(2,3,1)
    plot(XX(hor_pts),ZZ(hor_pts))
    xticks([-4800:800:4800])
    xtickangle(90)
    grid on;
    title(sprintf('horizontal pre'),'Interpreter','none');

    subplot(2,3,4)
    plot(YY(ver_pts),ZZ(ver_pts))
    xticks([0:400:4800])
    xtickangle(90)
    grid on;
    title(sprintf('vertical pre'),'Interpreter','none');

    subplot(2,3,2)
    plot(XX(hor_pts),ZZ1(hor_pts))
    xticks([-4800:800:4800])
    xtickangle(90)
    grid on;
    title(sprintf('post correction'),'Interpreter','none');

    subplot(2,3,5)
    plot(YY(ver_pts),ZZ1(ver_pts))
    xticks([0:400:4800])
    xtickangle(90)
    grid on;
    title(sprintf('post correction'),'Interpreter','none');

    x_row = round(size(XX,1)/2); %middle row for X-line
    y_row = round(size(XX,2)/2); %middle row for Y-line

    subplot(2,3,3)
    hold off;
    plot(XX(x_row,:),ZZ1(x_row,:))
    xticks([-6400:800:6400])
    xtickangle(90)
    hold on;
    plot(XX(x_row,:),ZZ(x_row,:))
    yticks([-6:1:3])
    ylim([-6 3]);
    grid on;
    title(sprintf('whole face comparison'),'Interpreter','none');

    subplot(2,3,6)
    hold off;
    plot(YY(:,y_row),ZZ1(:,y_row))
    xticks([-6400:800:6400])
    xtickangle(90)
    hold on;
    plot(YY(:,y_row),ZZ(:,y_row))
    yticks([-6:1:3])
    ylim([-6 3]);
    grid on;
    title(sprintf('whole face comparison'),'Interpreter','none');

    P = figure(2);
    set(P,'papersize',[10,30]);
    set(P,'position',[50/1024*screen(3) 150/768*screen(4) 800/1024*screen(3) 540/768*screen(4)]); %set fig according to screen & paper size
    set(P,'paperposition',[1 5 25,10]);
    saveas(P,[fname Title2 'tilt.png']);
end;
%**************************************************************************

if kj == 1;
figure(3)
xticks([-4800:800:4800]);
xtickangle(90);
yticks([-2:0.5:2.5]);
ylim([-2 2.5]);
hold on; grid on;
title(sprintf('x-line post correction'),'Interpreter','none');
kj = 2;
end


figure(3)
if i2 ~= 0;
    hold on
end
ZZ_m_x2 = ZZ_m_x - (x_line*px(1) + px(2));
plot(x_line,ZZ_m_x2)

i2 = i2+1;
leg_comb(i2) = Title2;

if i2 >5;
legend(leg_comb,'location','southeast')
legend('boxoff')
i3=i3+1;    
n2 = sprintf('%sxline_%s', fname, string(i3));
saveas(figure(3),[n2 'tilt.png']);

clf

i2=0;
kj=1;
end

clear test2

end
             
