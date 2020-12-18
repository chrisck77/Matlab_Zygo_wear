function DM=DDSmenu1(s);
%   Adds Menu item 'Titles' to the default figure
global LCOL;
global DM FIG % only global in this function

switch s
    case 'init titles on';
        FIG=gcf;
        hprn=uimenu(FIG,'label','DDSprint','callback','DDSmenu1(''hardcopy'');');

        h=uimenu(FIG,'label','Titles');
        DM(1)=uimenu(h,'label','Header','checked','on','callback','DDSmenu1(''head'');');
        DM(2)=uimenu(h,'label','Footer','checked','on','callback','DDSmenu1(''foot'');');
        DM(3)=uimenu(h,'label','Left','checked','on','callback','DDSmenu1(''left'');');
        DM(4)=uimenu(h,'label','Right','checked','on','callback','DDSmenu1(''right'');');
        DM(5)=uimenu(h,'label','Key','checked','on','callback','DDSmenu1(''key'');');
        for i=1:length(LCOL);
            labelstring=['Series ' num2str(i)];
            cbstring=['DDSmenu1(' num2str(i) ');'];
            DM(i+5)=uimenu(h,'label',labelstring,'checked','on','callback',cbstring);
        end;

        hcolor=uimenu(FIG,'label','DDScolor','callback','DDSmenu1(''color'');');

    case 'init titles off';
        FIG=gcf;
        hprn=uimenu(FIG,'label','DDSprint');
        h=uimenu(FIG,'label','Titles');
        DM(1)=uimenu(h,'label','titles','checked','off','callback','DDSmenu1(''head'');');

    case 'head'
        chk=get(DM(1),'checked');
        if strcmp(chk,'on');chk='off';else;chk='on';end
        set(DM(1),'checked',chk);
        h=findobj('type','axes');
        h1=findobj(h,'userdata','Head Axes');
        h2=get(h1,'children');
        if strcmp(chk,'on');
            set(h2,'visible','on');
        else
            set(h2,'visible','off');
        end;

    case 'foot'
        chk=get(DM(2),'checked');
        if strcmp(chk,'on');chk='off';else;chk='on';end
        set(DM(2),'checked',chk);
        h=findobj('type','axes');
        h1=findobj(h,'userdata','Foot Axes');
        h2=get(h1,'children');
        if strcmp(chk,'on');
            set(h2,'visible','on');
        else
            set(h2,'visible','off');
        end;

    case 'left'
        chk=get(DM(3),'checked');
        if strcmp(chk,'on');chk='off';else;chk='on';end
        set(DM(3),'checked',chk);
        h=findobj('type','axes');
        h1=findobj(h,'userdata','Left Axes');
        h2=get(h1,'children');
        if strcmp(chk,'on');
            set(h2,'visible','on');
        else
            set(h2,'visible','off');
        end;

    case 'right'
        chk=get(DM(4),'checked');
        if strcmp(chk,'on');chk='off';else;chk='on';end
        set(DM(4),'checked',chk);
        h=findobj('type','axes');
        h1=findobj(h,'userdata','Right Axes');
        h2=get(h1,'children');
        if strcmp(chk,'on');
            set(h2,'visible','on');
        else
            set(h2,'visible','off');
        end;

    case 'key'
        chk=get(DM(5),'checked');
        if strcmp(chk,'on');chk='off';else;chk='on';end
        set(DM(5),'checked',chk);
        h=findobj('type','axes');
        h1=findobj(h,'userdata','Key Axes');
        h2=get(h1,'children');
        if strcmp(chk,'on');
            set(h2,'visible','on');
        else
            set(h2,'visible','off');
        end;

    case {1,2,3,4,5,6,7,8,9,10,11,12}
        i=s;
        chk=get(DM(i+5),'checked');
        if strcmp(chk,'on');chk='off';else;chk='on';end
        set(DM(i+5),'checked',chk);
        h=findobj('color',LCOL(i,:));
        set(h,'visible','off');
        if strcmp(chk,'on');
            set(h,'visible','on');
        else
            set(h,'visible','off');
        end;
    case 'hardcopy'
        h=findobj('type','axes');
        h1=findobj(h,'userdata','Key Axes');
        axes(h1);
        axis off;  % turns the axis lines off so they do not appear on white print out
        %    print -opengl;      %opengl is faster than default (200KB compared to 2.6MB)
        axes(h1);
        %   axis on;

    case 'color'
        ddscolor;

end;


