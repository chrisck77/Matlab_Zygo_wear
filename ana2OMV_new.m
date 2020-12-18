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

%idxPin=find(ZZ<-10);

idxPin=find(ZZ<85);
%**************************************************************************
% create vectors of pin which work faster in the angle finding loop below
%**************************************************************************
[AA RR]=cart2pol(XX,YY); AA=AA*180/pi; % Convert to polar cordinates :)

Apin=AA(idxPin);
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
% loop round Angs looking for max lift along radii within an angle range
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
% Plotting main data
%**************************************************************************

if plotcase==1 || plotcase ==3; 
% 
     axes(ax(5));
     hold on;
     resolution=1;
     h(2)=pcolor(XX(1:resolution:end,1:resolution:end),YY(1:resolution:end,1:resolution:end),ZZ(1:resolution:end,1:resolution:end));
     set(h(2),'EdgeColor','none');
    caxis([-50 1]);hBar=colorbar;
    set(hBar,'ytick',-50:5:1);
    Angles=(0:1:360)*pi/180;
%     title(test2(1:end-4),'Interpreter','none');
    
%     plot(XofMax,YofMax,'color',[0 1 0],'linewidth',2.5);
    AngleGroups={[89 91];[44 46];[-1 1];[-46 -44];[-91 -89];[-136 -134];[179 181];[134 136]}; % define arcs within which to look for seat height
    for iGroup=1:size(AngleGroups,1)
        AngleGroup=AngleGroups{iGroup};
        [Xarc Yarc]=pol2cart(AngleGroup*pi/180,6400); %was 3000 for radius
        plot([0 Xarc(1)],[0 Yarc(1)],'color',PlotColor(iGroup,:),'linew',1);
        plot([0 Xarc(2)],[0 Yarc(2)],'color',PlotColor(iGroup,:),'linew',1);
    end
    clear iGroup;
 end
 
%**************************************************************************
% Volume removed Calculation
%**************************************************************************    
ZZ2 = ZZ;
ZZ2(ZZ2>0) = 0; %any value >0 set to 0 (normally close to 0)
ZZ2 = fillmissing(ZZ2,'linear');   %fillmissing using values in same column
ZZ2 = fillmissing(ZZ2,'linear',2); %fillmissing using values in same row				
ZZ2(ZZ2>0) = 0; %in case any extrapolate above 0 during linear interpolation step above

o_r = floor((12.15*1000/2)/(pixels_ratio*Conf.CameraRes * 1e6));%1000 to convert mm to microns, 1e6 to convert m to microns
i_r = ceil((10.15*1000/2)/(pixels_ratio*Conf.CameraRes * 1e6)); 
width=nclms; height=nrows; %nclms = size(ZZ,2) = width, nrows = size(ZZ,1)
cX = (nclms/2) +0.5;  cY = (nrows/2) +0.5; %centre coordinates ie cX is no. of columns to centre	
[W,H]=meshgrid(1:width, 1:height); 
arr_mask=sqrt((W-cX).^2+(H-cY).^2); 
arr_mask_h_microns = ((arr_mask*pixels_ratio*Conf.CameraRes*1e6)-5000)*(.015/1.2); %expected height in microns at that radius according to drawing of 15 microns per 1.2mm from 5mm from centre (5mm is id radius)
mask= arr_mask >= i_r & arr_mask <= o_r;
mask = double(mask);
mask(mask==0)=NaN; 
ZZ2 = ZZ2 .*mask; 

i_r_in_mm = i_r * (pixels_ratio*Conf.CameraRes*1e6)/1000; % note target is 10.15mm, chosen to be closet to this or above in terms of pixels
o_r_in_mm = o_r * (pixels_ratio*Conf.CameraRes*1e6)/1000; % note target is 10.15mm, chosen to be closet to this or below in terms of pixels

volum1_1 =  -pi * (o_r_in_mm^2 - i_r_in_mm^2) * (nanmean(ZZ2,'All')/1000); % volume in mm3
vol_1_str = strcat("OMV material removed = ", num2str(round(volum1_1,3))," mm3");
annotation('textbox',[.5 .25 .1 .2],'String', vol_1_str,'EdgeColor','none');

ZZ3 = ZZ;
ZZ3(ZZ3>0) = 0; %any value >0 set to 0 (normally close to 0)			
ZZ3 = ZZ3 .*mask; 
volum2_1 =  -pi * (o_r_in_mm^2 - i_r_in_mm^2) * (nanmean(ZZ3,'All')/1000); % volume in mm3
vol_2_str = strcat("OMV alternative calc material removed = ", num2str(round(volum2_1,3))," mm3");
annotation('textbox',[.5 .1 .1 .2],'String', vol_2_str,'EdgeColor','none');

%**************************************************************************
% Plotting Masks
%**************************************************************************    
%axes(ax(11)); % plot mask
%hold on;
%resolution=1;
%h(2)=pcolor(XX(1:resolution:end,1:resolution:end),YY(1:resolution:end,1:resolution:end),ZZ2(1:resolution:end,1:resolution:end));
%set(h(2),'EdgeColor','none'); caxis([-50 1]);

%**************************************************************************
% Volume removed Calculation per segment (8 segments)
%************************************************************************** 
AngleGroups2={[0 45];[45 90];[90 135];[135 180];[-180 -135];[-135 -90];[-90 -45];[-45 0]};
vol_segm = NaN(size(AngleGroups2,1),1); %size of the numbe of angle sements
    for iGroup2=1:size(AngleGroups2,1)
        AngleGroup2=AngleGroups2{iGroup2};
        idxGroupCo2{iGroup2}=find(AA>AngleGroup2(1)&AA<=AngleGroup2(2)&~isnan(ZZ2)&RR>4000&RR<6500); %#ok<AGROW> % find points that lie within arc %M Smith added ZZ>4
        [RRs2 iSortCo2{iGroup2}]=sort(RR(idxGroupCo2{iGroup2})); %#ok<AGROW>
        ZZ_segm=ZZ2(idxGroupCo2{iGroup2}(iSortCo2{iGroup2}));  
        ZZ_segm_mean = mean(ZZ_segm);
        vol_segm(iGroup2) = -pi * (o_r_in_mm^2 - i_r_in_mm^2) * (ZZ_segm_mean/8000); % volume in mm3
    end;
%**************************************************************************
% Seat Profile Lines
%**************************************************************************     
    AngleGroups3 = AngleGroups;
    AngleGroups3{5,1}(1) = -79;
    AngleGroups3{5,1}(2) = -77;

    for iGroup=1:size(AngleGroups,1)
        AngleGroup=AngleGroups{iGroup};
        idxGroupCo{iGroup}=find(AA>AngleGroup(1)&AA<=AngleGroup(2)&~isnan(ZZ)&RR>4000&RR<6500&ZZ<4); %#ok<AGROW> % find points that lie within arc %M Smith added ZZ>4
        [RRs iSortCo{iGroup}]=sort(RR(idxGroupCo{iGroup})); %#ok<AGROW>
        
%        idxGroupCo3{iGroup}=find(AA>AngleGroups3(1)&AA<=AngleGroup3(2)&~isnan(ZZ)&RR>4000&RR<6500&ZZ<4); %#ok<AGROW> % find points that lie within arc %M Smith added ZZ>4
 %       [RRs3 iSortCo3{iGroup}]=sort(RR(idxGroupCo3{iGroup})); %#ok<AGROW>
  %     zeropointZZ=(find(RR(idxGroupCo3{iGroup}(iSortCo3{iGroup}))<4882&RR(idxGroupCo3{iGroup}(iSortCo3{iGroup}))>4852));
     %  zseat=ZZ(idxGroupCo3{iGroup}(iSortCo3{iGroup}));         
   
        % point in the un-worn area, however the large whole sometimes is
        % captured (on the pink trace) hence different routine for that
        % igroup
        zeropointZZ=(find(RR(idxGroupCo{iGroup}(iSortCo{iGroup}))<4882&RR(idxGroupCo{iGroup}(iSortCo{iGroup}))>4852));
        zseat=ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}));
        
        zeronumber=zseat(zeropointZZ,1);
        zeronumber=mean(zeronumber);
        ZZshift=seat0pt-zeronumber;
        
        ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))=ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))+ZZshift;
        
%         zeropointRR=(find(ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))<-2&ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))>-5));
%         rseat=RR(idxGroupCo{iGroup}(iSortCo{iGroup}));
%         zeronumberR=rseat(zeropointRR,1);
%         zeronumberR=mean(zeronumberR);
%         RRshift=3900-zeronumberR;
%         RR(idxGroupCo{iGroup}(iSortCo{iGroup}))=RR(idxGroupCo{iGroup}(iSortCo{iGroup}))+RRshift;
        
    end;

%**************************************************************************
% Plotting Profile Lines
%**************************************************************************

if plotcase==1 || plotcase ==3;

    axes(ax(2));
    rrfin = zeros(2000,8);
    zzfin = zeros(2000,8);
    hold on;
%     title(test1(1:end-4),'Interpreter','none');
    for iGroup=1:size(AngleGroups,1)
        rr=RR(idxGroupCo{iGroup}(iSortCo{iGroup}));
        s=length(rr);
        z=length(rrfin);
        rrfin(:,iGroup)=[rr;zeros(z(1)-s(1),1)];
        rrfin(rrfin==0) = nan;
        
        zz=ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}));
        s1=length(zz);
        z1=length(zzfin);
        zzfin(:,iGroup)=[zz;zeros(z1(1)-s1(1),1)];
        zzfin(zzfin==0) = nan;
        h(4)=plot(rrfin(:,iGroup),zzfin(:,iGroup),'color',PlotColor(iGroup,:),'linew',1.5);
    end
%     clear AA RR ZZplane Apin Rpin Xpin Ypin Zpin idxPin;
    
end

%**************************************************************************
% Plotting Average Profile Lines
%**************************************************************************
% if plotcase == 1
% rravg2 = mean(rrfin,2,'omitnan');
% zzavg2 = mean(zzfin,2,'omitnan');
% axes(ax(3));  
% hold on;
% h(5)=plot(rravg2,zzavg2,'color',PlotColor(2,:),'linew',1.5);
% legend({'OMV 1', 'OMV 2'},'Location','northwest');
% end
