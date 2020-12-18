switch pltflag

    case 'init'

        f1=figure(1);

        ddsfigOMV;delete(ax(1));
%         set(gcf,'resize','off','PaperPositionMode','auto')
        set(gcf,'windowbuttondownfcn','DDSzoomfig(gco,HkeyAX);');
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
        PlotColor1=[0 0 1;0.8 0.8 0.8;1 1 0;0 1 1;1 0 1;0 0 0;0 1 0;1 0 0];
        %         clf;

        ax(8)=axes;hold on;grid on;
        ax(2)=axes;hold on;grid on;
%         ax(3)=axes;hold on;grid on;
        ax(4)=axes;hold on;grid on;
        ax(5)=axes;hold on;grid on;
        
        
        str1 = test1;
        str_trim1 = str1(1:strfind(str1,'.')-1);
        Title1 = str_trim1;
        
        str2 = test2;
        str_trim2 = str2(1:strfind(str2,'.')-1);
        Title2 = str_trim2;
      
        %**************************************************************************
        % Axis 1 - Seat Profiles 1
        %**************************************************************************
        axes(ax(8));
        axis([4600 6500 -50 5]); %was 3900,5200
        set(ax(8),'units','normalized','pos',[0.04 0.55 .4 .4]);
        set(gca,'layer','top','ytick',-50:5:2,'xtick',4600:200:6500) %was 3900,5200
        set(gca,'xminorgrid','on','yminorgrid','on');
        title(sprintf('Profile Pump Body %s', Title1),'Interpreter','none');
        xlabel('Radius (µm)');
        ylabel('Profile (µm)');
        
        %**************************************************************************
        % Axis 2 - Seat Profiles 2
        %**************************************************************************

        axes(ax(2));
        axis([4600 6500 -50 5 -50 5]);  %was 3900,5200
        set(ax(2),'units','normalized','pos',[0.57 0.55 .4 .4]);
        set(gca,'layer','top','ytick',-50:5:2,'xtick',4600:200:6500); %was 3900,5200
        set(gca,'xminorgrid','on','yminorgrid','on');
        title(sprintf('Profile OMV %s', Title2),'Interpreter','none');
        xlabel('Radius (µm)');
        ylabel('Profile (µm)');
        
        %**************************************************************************
        % Axis 3 - Average profiles of both
        %**************************************************************************
%         axes(ax(3));
%         axis([1800 2600 -50 5]);
%         set(ax(3),'units','normalized','pos',[0.3 0.08 .4 .25]);
%         set(gca,'layer','top','ytick',-50:5:2,'xtick',1800:200:2600);
%         title('Seat Profile Average');
%         xlabel('Radius (µm)');
%         ylabel('Profile (µm)');

        
        %**************************************************************************
        % Axis 4 - Zygo Trace Pin Seat
        %**************************************************************************

        axes(ax(4));
        axis([-7000 7000 -7000 7000]);%was 3500
        axis square;
        set(ax(4),'units','normalized','pos',[0.06 0.02 .4 .4]);
        set(gca,'layer','top','xtick',-7000:800:7000,'ytick',-7000:800:7000,'xticklabel',[],'yticklabel',[]); %ws 3500:400:3500
        setappdata(gcf,'XlabDiv','100µm per div');
        title(sprintf('Pump Body %s', Title1),'Interpreter','none');
        
        %**************************************************************************
        % Axis 5 - Zygo Trace Pin Seat 2
        %**************************************************************************

        axes(ax(5));
        axis([-7000 7000 -7000 7000]);%was 3500
        axis square;
        set(ax(5),'units','normalized','pos',[0.59 0.02 .4 .4]);
        set(gca,'layer','top','xtick',-7000:800:7000,'ytick',-7000:800:7000,'xticklabel',[],'yticklabel',[]); %was 3500:400:3500
        setappdata(gcf,'XlabDiv','100µm per div');
        title(sprintf('OMV %s', Title2),'Interpreter','none');

end % end switch pltflag
