switch pltflag

    case 'init'

        figure(1);

        ddsfigOMVsingle;delete(ax(1));
        set(gcf,'resize','off','PaperPositionMode','auto')
%         set(gcf,'windowbuttondownfcn','DDSzoomfig(gco,HkeyAX);');
        defaultBackground = get(0,'defaultUicontrolBackgroundColor');
        set(gcf,'Color',defaultBackground);
%         set(gcf,'pos',[90 90 900 700]);
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
        %         clf;

        ax(8)=axes;hold on;grid on
        ax(4)=axes;hold on;grid on
        
        
        str_trim = test1(1:strfind(test1,'.')-1);
        Title1 = str_trim;
     
      
        %**************************************************************************
        % Axis 1 - Seat Profiles 1
        %**************************************************************************
        axes(ax(8));
        axis([3900 5200 -50 5]);
        set(ax(8),'units','normalized','pos',[0.1 0.55 .8 .4]);
        set(gca,'layer','top','ytick',-50:5:2,'xtick',3900:100:5200)
        set(gca,'xminorgrid','on','yminorgrid','on');
        title(sprintf('Profile OMV %s', Title1));
        xlabel('Radius (µm)');
        ylabel('Profile (µm)');;
      
        %**************************************************************************
        % Axis 4 - Zygo Trace Pin Seat
        %**************************************************************************

        axes(ax(4));
        axis([-3500 3500 -3500 3500]);
        axis square;
        set(ax(4),'units','normalized','pos',[0.32 0.02 .4 .4]);
        set(gca,'layer','top','xtick',-3500:400:3500,'ytick',-3500:400:3500,'xticklabel',[],'yticklabel',[]); 
        setappdata(gcf,'XlabDiv','100µm per div');
        title(sprintf('OMV %s', Title1));
        
    
end % end switch pltflag
