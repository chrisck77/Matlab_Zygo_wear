
% After calling DDSfig the user will have access to workspace variables
% Hheadax Hfootax Hleftax Hrightax and Hkeyax which are handles to the various text axes
% Colors and lines styles for different series will be defined
% These can then be refered to by the series number (iser) in the plotting routine (DDSplot)

global TXSIZ LCOL LWID LDSH LSYM LSIZ WSYM NSYM

figure(gcf);
clf;
colordef('white');
DDSmenu1('init titles on');    % use this to setup menu functions

set(gcf,'paperunits','centimeters');
set(gcf,'paperorientation','landscape');
set(gcf,'papersize', [29.6674 20.984]);            %A4
set(gcf,'paperposition',[1.83 2.99 26 15]);        %size to suit space in powerpoint frame  (26cm wide 15cm high
screen=get(0,'screensize');                       %get users screen size
set(gcf,'position',[50/1024*screen(3) 150/768*screen(4) 936/1024*screen(3) 540/768*screen(4)]); %set fig according to screen & paper size

%set(gcf,'color',[0.97 0.97 0.97]);      %lighten background so coloured labels show up

if screen(3)>1024
    textsize=9;
else
    textsize=9;
end

set(gcf,'defaultaxesfontsize',textsize);
if exist('nBatchColor')==0 ; nBatchColor=1;end;
switch nBatchColor
    case 1
        LCOL=[0.00  0.00  1.00
              1.00  0.00  0.00
              0.00  0.88  0.00
              0.01  0.01  0.01
              1.0  0    1.0
            0.2  0.8  0.9
            0.94 0.8 0
            0.6  0.6  0.6
            0.8  0    0
            0    0.65 0
            0.5    0    1.0
            1.0  0.5  0
            0    0    1.0
            1.0  0  0
            0    0.88 0
            0.01   0.01  0.01
            1.0  0   1.0
            0.2  0.8  0.9
            0.94 0.8 0
            0.6  0.6  0.6
            0.8  0    0
            0    0.65 0
            0.5    0    1.0
            1.0  0.5  0 ];

    case 3

        LCOL=[0    0    1.0
            0    0    1.0
            0    0    1.0
            1.0  0  0
            1.0  0  0
            1.0  0  0
            0    0.88 0
            0    0.88 0
            0    0.88 0
            0.01   0.01  0.01
            0.01   0.01  0.01
            0.01   0.01  0.01
            1.0  0   1.0
            1.0  0   1.0
            1.0  0   1.0
            0.2  0.8  0.9
            0.2  0.8  0.9
            0.2  0.8  0.9
            0.94 0.8 0
            0.94 0.8 0
            0.94 0.8 0
            0.6  0.6  0.6
            0.6  0.6  0.6
            0.6  0.6  0.6
            0.8  0    0
            0.8  0    0
            0.8  0    0
            ];
end; % switch nBatchColor

%LWID=[1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5];
LWID=ones(12,1)*1.5;
LDSH=[' -';' -';' -';' -';' -';' -';' -';' -';' -';' -';' -';' -';];
LSYM='ox+sd^ox+sd^';
LSIZ=[8 8 8 8 8 8 8 8 8 8 8 8];
WSYM=[2 2 2 2 2 2 2 2 2 2 2 2];

NSYM=0;

%Define head foot right and left axes for general comments
%Set default text sizes and orientation

axheight=2*12/64*2.54/15;   %64 points per inch and 15cm high page
HheadAX=axes('pos',[0.0 1-axheight 1 axheight]);axes(HheadAX);axis off;axis ij;axis([0 1 0.5 2.5]);
set(gca,'defaulttextfontsize',12,'defaulttexthoriz','center','defaulttextvert','mid');
set(gca,'userdata','Head Axes');
axheight=1*8/64*2.54/26;   %64 points per inch and 26cm wide page
HrightAX=axes('pos',[1-axheight 0 axheight 1]);axes(HrightAX);axis off;axis([0.5 1.5 0 1]);
set(gca,'defaulttextfontsize',8,'defaulttexthoriz','left','defaulttextvert','mid','defaulttextrotation',90);
set(gca,'userdata','Right Axes');
text(1, 1,date,'horiz','right');
htx=text(1,0,cd,'interpreter','none');   % label current directory and date by default
HleftAX=axes('pos',[0.0 0 axheight 1]);axes(HleftAX);axis off;axis([0.5 1.5 0 1]);
set(gca,'defaulttextfontsize',8,'defaulttexthoriz','left','defaulttextvert','mid','defaulttextrotation',90);
set(gca,'userdata','Left Axes');

axheight=1*10/64*2.54/15;   %64 points per inch and 15cm high page
HfootAX=axes('pos',[0.0 0 1 axheight]);axes(HfootAX);axis off;axis ij;axis([0 1 0.5 1.5]);
set(gca,'userdata','Foot Axes');

%Define a key axes

% Nseries=12;   %number of lines in the key axis
% TXSIZ=8;
% axheight=Nseries*(TXSIZ)/64*2.54/15;   %64 points per inch and 15cm high page
% HkeyAX=axes('pos',[0.05 .05 0.9 axheight]);axes(HkeyAX);axis on;axis ij;axis([0 1 0.5 Nseries+0.5]);
% set(gca,'defaulttextfontsize',TXSIZ,'defaulttextvert','mid');
% CL=get(gca,'color');
% set(gca,'xticklabel',[],'yticklabel',[]);
% set(gca,'xcolor',CL,'ycolor',CL);
% set(gca,'userdata','Key Axes');


%Set up a first plotting axis

ax(1)=axes('pos',[0.1 0.13+axheight 0.8 0.74-axheight]);
grid on;
hold on;

