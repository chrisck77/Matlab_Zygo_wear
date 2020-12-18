%**************************************************************************
% Read height data
% note YY and XX reversed to orientate data as on drawing
%**************************************************************************

[XX YY ZZ Conf]=fnImportZygoPhaseHalf(fnmLift1); %m-file to interpret .dat file 

%**************************************************************************
% Calibrate the X and Y directions
%**************************************************************************

%Conf.CameraRes_a= (Conf.NumberofPhaseBytes * Conf.WavelengthIn * Conf.IntfScaleFactor * Conf.ObliquityFactor) / (Conf.PhaseRes * 10)

Conf.CameraRes=4.4179e-006;

YY=(YY)*Conf.CameraRes*1e6;
XX=(XX)*Conf.CameraRes*1e6;

%**************************************************************************
% Give a rough center
%**************************************************************************

nrows=size(ZZ,1);nclms=size(ZZ,2);
% 
% XX=XX-(nclms-68)*Conf.CameraRes*1e6; %to use with C2 revised lift mask 14/01/2013 %% -68 %%
% YY=YY-(nrows+10)*Conf.CameraRes*1e6; %% +10 %%

XX=XX-(nclms)*Conf.CameraRes*1e6; 
YY=YY-(nrows)*Conf.CameraRes*1e6; 

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
    idxAng=find(Apin>Ang&Apin<Ang+0.5&Rpin<2100&Rpin>2000&Zpin<-16);
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
% Seat Profile Lines
%**************************************************************************

    AngleGroups={[89 91];[44 46];[-1 1];[-46 -44];[-91 -89];[-136 -134];[179 181];[134 136]}; % define arcs within which to look for seat height
         
    for iGroup=1:size(AngleGroups,1)
        AngleGroup=AngleGroups{iGroup};
        idxGroupCo{iGroup}=find(AA>AngleGroup(1)&AA<=AngleGroup(2)&~isnan(ZZ)&RR>2000&RR<3000&ZZ<16); %#ok<AGROW> % find points that lie within arc %M Smith added ZZ>4
        [RRs iSortCo{iGroup}]=sort(RR(idxGroupCo{iGroup})); %#ok<AGROW>
        
%         zeropointZZ=(find(RR(idxGroupCo{iGroup}(iSortCo{iGroup}))<1990&RR(idxGroupCo{iGroup}(iSortCo{iGroup}))>1970));
%         zseat=ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}));
%         zeronumber=zseat(zeropointZZ,1);
%         zeronumber=mean(zeronumber);
%         ZZshift=seat0pt-zeronumber;
%         ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))=ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))+ZZshift;
        
%         zeropointRR=(find(ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))<-2&ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}))>-5));
%         rseat=RR(idxGroupCo{iGroup}(iSortCo{iGroup}));
%         zeronumberR=rseat(zeropointRR,1);
%         zeronumberR=mean(zeronumberR);
%         RRshift=0-zeronumberR;
%         RR(idxGroupCo{iGroup}(iSortCo{iGroup}))=RR(idxGroupCo{iGroup}(iSortCo{iGroup}))+RRshift;
        
    end;


%**************************************************************************
% Plotting main data
%**************************************************************************

 if plotcase==1; 
% 
    axes(ax(4));
     hold on;
     resolution=1;
     h(2)=pcolor(XX(1:resolution:end,1:resolution:end),YY(1:resolution:end,1:resolution:end),ZZ(1:resolution:end,1:resolution:end));
     set(h(2),'EdgeColor','none');
    caxis([-50 1]);hBar=colorbar;
    set(hBar,'ytick',-50:5:1);
    Angles=(0:1:360)*pi/180;
%     title(test1(1:end-4),'Interpreter','none');
    
%     plot(XofMax,YofMax,'color',[0 1 0],'linewidth',2.5);

    for iGroup=1:size(AngleGroups,1)
        AngleGroup=AngleGroups{iGroup};
        [Xarc Yarc]=pol2cart(AngleGroup*pi/180,3000);
        plot([0 Xarc(1)],[0 Yarc(1)],'color',PlotColor1(iGroup,:),'linew',1);
        plot([0 Xarc(2)],[0 Yarc(2)],'color',PlotColor1(iGroup,:),'linew',1);
    end
    clear iGroup;
 end
 
%**************************************************************************
% Plotting Profile Lines
%**************************************************************************

if plotcase==1

    axes(ax(8));
    rrfin = zeros(2000,8);
    zzfin = zeros(2000,8);
    hold on;
%     title(test1(1:end-4),'Interpreter','none');
    for iGroup=1:size(AngleGroups,1)
        rr=2*RR(idxGroupCo{iGroup}(iSortCo{iGroup}));
        s=length(rr);
        z=length(rrfin);
        rrfin(:,iGroup)=[rr;zeros(z(1)-s(1),1)];
        rrfin(rrfin==0) = nan;
        
        
        zz=ZZ(idxGroupCo{iGroup}(iSortCo{iGroup}));
        s1=length(zz);
        z1=length(zzfin);
        zzfin(:,iGroup)=[zz;zeros(z1(1)-s1(1),1)];
        zzfin(zzfin==0) = nan;
        h(4)=plot(rrfin(:,iGroup),zzfin(:,iGroup),'color',PlotColor1(iGroup,:),'linew',1.5);
    end
%     clear AA RR ZZplane Apin Rpin Xpin Ypin Zpin idxPin;
    
end

%**************************************************************************
% Plotting Average Profile Lines
%**************************************************************************
% if plotcase == 1
% rravg1 = mean(rrfin,2,'omitnan');
% zzavg1 = mean(zzfin,2,'omitnan');
% axes(ax(3));  
% hold on;
% h(5)=plot(rravg1,zzavg1,'color',PlotColor(1,:),'linew',1.5);
% end
