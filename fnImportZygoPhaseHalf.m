function [XX,YY,PP,ZygoConfig]=fnImportZygoPhaseHalf(varargin)
% [XX YY PP,ZygoConfig]=fnImportZygoPhase(varargin)
% John Ginger 23/4/09 Delphi Diesel System (Modified and limited by AT
% Harcombe 12/08/09)
%This function is used to import phase information from MetroPro for the Zygo range of instruments
%
%Inputs
%Outputs
%X Y and Z matricies and ZygoConfig

switch nargin
    case 0
        [a b]=uigetfile('.dat');
        fid = fopen([b a]);
        
    case 1
        fid = fopen(varargin{1});
        
    otherwise
        error('Unexpected Inputs');

end

%Check if it is the Correct File
MagicNumber=fread(fid, 1, 'int32', 'ieee-be');
% if(MagicNumber~= -2011495569); error('This is not a valid metropro file'); end

%**************************************************************************
%% Read In Header information
ZygoConfig.HeaderFormat=fread(fid, 1, 'int16', 'ieee-be');
ZygoConfig.HeaderSize=fread(fid, 1, 'int32', 'ieee-be');
ZygoConfig.SoftwareType=fread(fid, 1, 'int16', 'ieee-be');
ZygoConfig.SoftwareDate=fread(fid, 30, '*char', 'ieee-be');
int16=fread(fid, 8, 'int16', 'ieee-be');
ZygoConfig.MajorVersion=int16(1);
ZygoConfig.MinorVersion=int16(2);
ZygoConfig.BugVersion=int16(3);
ZygoConfig.IntensOriginX=int16(4);
ZygoConfig.IntensOriginY=int16(5);
ZygoConfig.IntensWidth=int16(6);
ZygoConfig.IntensHeight=int16(7);
ZygoConfig.NBuckets=int16(8);
ZygoConfig.IntensityRange=fread(fid, 1, 'uint16', 'ieee-be');
ZygoConfig.NumberofIntensityBytes=fread(fid, 1, 'int32', 'ieee-be');
ZygoConfig.PhaseOriginX=fread(fid, 1, 'int16', 'ieee-be');
ZygoConfig.PhaseOriginY=fread(fid, 1, 'int16', 'ieee-be');
ZygoConfig.PhaseWidth=fread(fid, 1, 'int16', 'ieee-be');
ZygoConfig.PhaseHeight=fread(fid, 1, 'int16', 'ieee-be');
ZygoConfig.NumberofPhaseBytes=fread(fid, 1, 'int32', 'ieee-be');
ZygoConfig.Timestamp=fread(fid, 1, 'int32', 'ieee-be');
ZygoConfig.Comment=fread(fid, 82, '*char', 'ieee-be');
ZygoConfig.Source=fread(fid, 1, 'int16', 'ieee-be');

fseek(fid,164,'bof');
ZygoConfig.IntfScaleFactor=fread(fid, 1, 'float32', 'ieee-be');
ZygoConfig.WavelengthIn=fread(fid, 1, 'float32', 'ieee-be');
ZygoConfig.NumericAperture=fread(fid, 1, 'float32', 'ieee-be');
ZygoConfig.ObliquityFactor=fread(fid, 1, 'float32', 'ieee-be');
ZygoConfig.Magnification=fread(fid, 1, 'float32', 'ieee-be');
ZygoConfig.CameraRes=fread(fid, 1, 'float32', 'ieee-be');

fseek(fid,218,'bof');
ZygoConfig.PhaseRes=fread(fid, 1, 'int16', 'ieee-be');
if(ZygoConfig.PhaseRes)
   ZygoConfig.PhaseRes=32768;
else
   ZygoConfig.PhaseRes=4096;
end% 

%**************************************************************************
%% Read in Actual Data
fseek(fid,ZygoConfig.HeaderSize+ZygoConfig.IntensWidth*ZygoConfig.IntensHeight*2,'bof');  % skip intesity data (note 2 bytes/point)

%Read in and calibrate Phase
PhaseData=fread(fid, (ZygoConfig.PhaseWidth * ZygoConfig.PhaseHeight), 'int32', 'ieee-be'); %Read in Phase Data
PhaseData(find(PhaseData>=2147483640))=NaN; %Get rid of non real values for Phase Data
PhaseData=PhaseData*((ZygoConfig.IntfScaleFactor*ZygoConfig.ObliquityFactor*ZygoConfig.WavelengthIn)/ZygoConfig.PhaseRes)*1000000;
PP=reshape(PhaseData,ZygoConfig.PhaseWidth,ZygoConfig.PhaseHeight);
PP=fliplr(PP)';
%Generate X and Y co-ordinate arrays
XX=repmat([1:ZygoConfig.PhaseWidth],ZygoConfig.PhaseHeight,1);
YY=repmat([1:ZygoConfig.PhaseHeight]',1,ZygoConfig.PhaseWidth);


XX(2:2:end,:)=[];
YY(2:2:end,:)=[];
PP(2:2:end,:)=[];

XX(:,2:2:end)=[];
YY(:,2:2:end)=[];
PP(:,2:2:end)=[];


fclose(fid);


