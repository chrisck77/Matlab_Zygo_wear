
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch plotcase
    
    case 0 % testlist grouping
        
        iDesLev=menu('Choose Data Folder',{,'User Folder','Cancel'});
        if iDesLev==0 || iDesLev==3; return; end;
       
%**************************************************************************
%**************************************************************************
    case 1 % joint
        
        clear h
        
        MSTRtype=1;
        iSeatAng=0;
        seat0pt=0;
        
        if exist('iDesLev')==0;plotcase=0;RepltZygoOMV;end;plotcase=1;
       if iDesLev==1;[test1,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab'); 
        else if iDesLev==2;[test1,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab');end;
        end;
        fnmLift1=[Root test1];

        if iDesLev==1;[test2,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab');
        else if iDesLev==2;[test2,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab');end;
        end;
        fnmLift2=[Root test2];
        
        pltflag='init';axJointOMV;
        
        anaOMV;
        ana2OMV;
        
%**************************************************************************

    case 2 
      
        
          clear h
        
        MSTRtype=1;
        iSeatAng=0;
        seat0pt=0;
        
    
         if exist('iDesLev')==0;plotcase=0;RepltZygoOMV;end;plotcase=1;
       if iDesLev==1;[Root] = uigetdir('C:\Data\DAF\','Select data folder'); 
        else if iDesLev==2;[Root] = uigetdir('C:\Data\DAF\','Select data folder');end;
        end;
  
        
        Root = [Root '\'];
        
        tests=ls(fullfile(Root,'*.dat'));
        
           for i=1:2:size(tests)
    
          test1=tests(i+1,:);
          test2=tests(i,:);
    
          fnmLift1=[Root test1];
          fnmLift2=[Root test2];
        
          pltflag='init';axJointOMV;
       
          anaOMV;
          ana2OMV;
 
          fname= [Root 'Output\'];
 
          set(gcf,'PaperOrientation','portrait');
          saveas(gca, [fname Title1 '.png']);
          
          clear test1
          clear test2
       
        end
 %**************************************************************************
    case 3 % joint
        
        clear h
        
        MSTRtype=1;
        iSeatAng=0;
        seat0pt=0;
        
        if exist('iDesLev')==0;plotcase=0;RepltZygoOMV;end;plotcase=1;
       if iDesLev==1;[test1,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab'); 
        else if iDesLev==2;[test1,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab');end;
        end;
        fnmLift1=[Root test1];

        if iDesLev==1;[test2,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab');
        else if iDesLev==2;[test2,Root] = uigetfile('*.dat','Select data','C:\Data\DAF\Zygo Traces For Matlab');end;
        end;
        fnmLift2=[Root test2];
        
        pltflag='init';axJointOMV_new;
        %pltflag='init';Debug_axJointOMV_new;
        
        anaOMV_new;
        ana2OMV_new;
     
%**************************************************************************

    case 4 
      
        
          clear h
        
        MSTRtype=1;
        iSeatAng=0;
        seat0pt=0;
        
    
         if exist('iDesLev')==0;plotcase=0;RepltZygoOMV;end;plotcase=1;
       if iDesLev==1;[Root] = uigetdir('C:\Data\DAF\','Select data folder'); 
        else if iDesLev==2;[Root] = uigetdir('C:\Data\DAF\','Select data folder');end;
        end;
  
        
        Root = [Root '\'];
        
        tests=ls(fullfile(Root,'*.dat'));
        
        list_volum = strings((size(tests,1)/2)+1,5); %table of pumps with volume removed values, empty to start, add header row
        list_volum(1,1)= 'Pump Number';
        list_volum(1,2)= 'PB material removed';
        list_volum(1,3)= 'PB alternative calc material removed';
        list_volum(1,4)= 'OMV material removed';
        list_volum(1,5)= 'OMV alternative calc material removed';
        list_volum2 = NaN(size(tests,1)/2,14); %double array for writing to csv file
        
        
           for i=1:2:size(tests)
    
          test1=tests(i+1,:);
          test2=tests(i,:);
    
          fnmLift1=[Root test1];
          fnmLift2=[Root test2];
        
          pltflag='init';axJointOMV_new;
          %pltflag='init';Debug_axJointOMV_new;
       
          anaOMV_new;
          ana2OMV_new;
          
          str_trim1_1 = str_trim1(1:8); % extract pump number from file, anything before '-'
          list_volum(((i+1)/2)+1,1) = str_trim1_1; %put into string array
          list_volum(((i+1)/2)+1,2) = volum1;
          list_volum(((i+1)/2)+1,3) = volum2;
          list_volum(((i+1)/2)+1,4) = volum1_1;
          list_volum(((i+1)/2)+1,5) = volum2_1;
          list_volum2((i+1)/2,1) = str2num(str_trim1_1);
          list_volum2((i+1)/2,2) = volum1;
          list_volum2((i+1)/2,3) = volum2;
          list_volum2((i+1)/2,4) = volum1_1;
          list_volum2((i+1)/2,5) = volum2_1;
          for ii2=1:size(vol_segm,1)
            list_volum2((i+1)/2,ii2+5) = vol_segm (ii2);
          end
          list_volum2((i+1)/2,14) = max(vol_segm) - min(vol_segm);
          
          fname= [Root 'Output\'];
 
          set(gcf,'PaperOrientation','portrait');
          saveas(gca, [fname Title1 '.png']);
          
          clear test1
          clear test2
       
           end
           
        filename_xls = 'vol_removed' ;
        Headers_xls = {'Pump Number', 'PB material removed', 'PB alternative calc material removed',...
            'OMV material removed', 'OMV alternative calc material removed',...
            'OMV vol segment 0-45','OMV vol segment 45-90','OMV vol segment 90-135','OMV vol segment 135-180',...
            'OMV vol segment 180-225','OMV vol segment 225-270','OMV vol segment 270-315','OMV vol segment 315-360'...
            'OMV max - min segment'};
        sheet =1;
        xlswrite(['C:\Data\DAF\Zygo Traces For Matlab\Output\' filename_xls '.xls'],Headers_xls,sheet,'A1');
        xlswrite(['C:\Data\DAF\Zygo Traces For Matlab\Output\' filename_xls '.xls'],list_volum2,sheet,'A2');               
       
  
end % end switch plotcase