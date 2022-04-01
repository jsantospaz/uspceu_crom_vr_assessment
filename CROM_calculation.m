clear
close all
clc
%%

SBJ = 124;
Freq = 90;

fc = 10;
fcT = 1;
fcV = 4;

[b,a] = butter(4,fc/(Freq/2));
[bT,aT] = butter(4,fcT/(Freq/2));
[bV,aV] = butter(4,fcV/(Freq/2));

opts = delimitedTextImportOptions("NumVariables", 13);

opts.DataLines = [2, Inf];
opts.Delimiter = ",";

opts.VariableNames = ["Var1", "Time", "Device", "X", "Y", "Z", "qW", "qX", "qY", "qZ", "aX", "aY", "aZ"];
opts.SelectedVariableNames = ["Time", "Device", "X", "Y", "Z", "qW", "qX", "qY", "qZ", "aX", "aY", "aZ"];
opts.VariableTypes = ["string", "datetime", "categorical", "double", "double", "double", "double", "double", ...
    "double", "double", "double", "double", "double"];

opts.ExtraColumnsRule = "addvars";
opts.EmptyLineRule = "read";

opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Device"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Time", "InputFormat", "HH:mm:ss.SSSS");

filename = "\Subject__"+SBJ+".txt";

Subject = readtable(filename, opts);

clear opts prompt

%%
Line_1 = ["Subject", "Rep1", "Rep2", "Rep3", "Min", "Max", "Mean", ...
                "CRep1", "CRep2", "CRep3", "CMin", "CMax", "CMean", ...
                "v1Max", "v2Max", "v3Max", "vMaxMean", ...
                "v1Min", "v2Min", "v3Min", "vMinMean", "vMean", ...
                "v1TMax", "v2TMax", "v3TMax", "vTMaxMean", ...
                "v1TMin", "v2TMin", "v3TMin", "vTMinMean",...
                "v1CMax", "v2CMax", "v3CMax", "vCMaxMean", ...
                "v1CMin", "v2CMin", "v3CMin", "vCMinMean", "vCMean"];
            
if exist('\Results_Flexion.csv', 'file')
    %We do not do anything
else
    writematrix(Line_1,'Results_Flexion.csv')
end

if exist('\Results_Rotation.csv', 'file')
    %We do not do anything
else
    writematrix(Line_1,'Results_Rotation.csv')
end

if exist('\Results_LatFlexion.csv', 'file')
    %We do not do anything
else
    writematrix(Line_1,'Results_LatFlexion.csv')
end

clear Line_1

Res_Folder = '/Processed_Results';

if exist(Res_Folder, 'dir')
    %We do not do anything
else
    mkdir(Res_Folder);
end

%%

[~,n]=size(Subject);

if n > 12
%     Subject.X = num2str(Subject.X);
%     Subject.Y = num2str(Subject.Y);
%     Subject.Z = num2str(Subject.Z);
%     Subject.qW = num2str(Subject.qW);
%     Subject.qX = num2str(Subject.qX);
%     Subject.qY = num2str(Subject.qY);
%     Subject.qZ = num2str(Subject.qZ);
%     Subject.aX = num2str(Subject.aX);
%     Subject.aY = num2str(Subject.aY);
%     Subject.aZ = num2str(Subject.aZ);
%     
%     Subject.X = strcat(Subject.X,'.',Subject.Y);
%     Subject.Y = strcat(Subject.Z,'.',Subject.qW);
%     Subject.Z = strcat(Subject.qX,'.',Subject.qY);
%     Subject.qW = strcat(Subject.qZ,'.',Subject.aX);
%     Subject.qX = strcat(Subject.aY,'.',Subject.aZ);
%     Subject.qY = strcat(Subject.ExtraVar1,'.',Subject.ExtraVar2);
%     Subject.qZ = strcat(Subject.ExtraVar3,'.',Subject.ExtraVar4);
    Subject.aX = strcat(Subject.ExtraVar5,'.',Subject.ExtraVar6);
    Subject.aY = strcat(Subject.ExtraVar7,'.',Subject.ExtraVar8);
    Subject.aZ = strcat(Subject.ExtraVar9,'.',Subject.ExtraVar10);
    
    
end

%%

SbjH = Subject(Subject.Device=="H",10:12);
SbjT = Subject(Subject.Device=="T",10:12);

if n > 12
    SbjH.aX = str2double(SbjH.aX);
    SbjH.aY = str2double(SbjH.aY);
    SbjH.aZ = str2double(SbjH.aZ);
    
    SbjT.aX = str2double(SbjT.aX);
    SbjT.aY = str2double(SbjT.aY);
    SbjT.aZ = str2double(SbjT.aZ);
end

clear filename i m n

%%

SbjH.aX = wrapTo180(SbjH.aX);
SbjH.aY = wrapTo180(SbjH.aY);
SbjH.aZ = wrapTo180(SbjH.aZ);

SbjT.aX = wrapTo180(SbjT.aX);
SbjT.aY = wrapTo180(SbjT.aY);
SbjT.aZ = wrapTo180(SbjT.aZ);

%% Flexion

figure('WindowState', 'maximized');
plot(SbjH.aX)
yline(0, 'm--', 'LineWidth', 1);

[xF1,~] = ginput(2);

for i = 1:2 
    xF1(i) = int32(xF1(i));
end

close figure 1
%%
SbjH_aX = SbjH.aX(xF1(1):xF1(2));
SbjT_aX = SbjT.aX(xF1(1):xF1(2));

SbjH_aXp = mean(SbjH_aX(1:9));
SbjT_aXp = mean(SbjT_aX(1:9));

SbjH_aX = SbjH_aX - SbjH_aXp;
SbjT_aX = SbjT_aX - SbjT_aXp;

SbjH_aX = wrapTo180(SbjH_aX);
SbjT_aX = wrapTo180(SbjT_aX);

SbjH_aX = filtfilt(b,a,SbjH_aX);
SbjT_aX = filtfilt(bT,aT,SbjT_aX);

figure('WindowState', 'maximized')
plot(SbjH_aX)
yline(0, 'm--', 'LineWidth', 1);

[xF2,~] = ginput(6);

for i = 1:6 
    xF2(i) = int32(xF2(i));
end

FHRep1 = SbjH_aX(xF2(1):xF2(2));
FHRep2 = SbjH_aX(xF2(3):xF2(4));
FHRep3 = SbjH_aX(xF2(5):xF2(6));

FTRep1 = SbjT_aX(xF2(1):xF2(2));
FTRep2 = SbjT_aX(xF2(3):xF2(4));
FTRep3 = SbjT_aX(xF2(5):xF2(6));

SbjH_aX = zeros(length(FHRep1)+length(FHRep2)+length(FHRep3),1);
SbjT_aX = zeros(length(FHRep1)+length(FHRep2)+length(FHRep3),1);

SbjH_aX(1:length(FHRep1),1) = FHRep1;
SbjH_aX(length(FHRep1)+1:length(FHRep1)+length(FHRep2),1) = FHRep2;
SbjH_aX(length(FHRep1)+length(FHRep2)+1:length(FHRep1)+length(FHRep2)+length(FHRep3),1) = FHRep3;

SbjT_aX(1:length(FHRep1),1) = FTRep1;
SbjT_aX(length(FHRep1)+1:length(FHRep1)+length(FHRep2),1) = FTRep2;
SbjT_aX(length(FHRep1)+length(FHRep2)+1:length(FHRep1)+length(FHRep2)+length(FHRep3),1) = FTRep3;

close figure 1

%%
MPD = int16(length(SbjH_aX)/3*0.75);
            
[~,locs_MAX_F] = findpeaks(SbjH_aX,'MinPeakHeight',30,'MinPeakDistance',MPD);
aX_inv = -SbjH_aX;
[~,locs_MIN_F] = findpeaks(aX_inv,'MinPeakHeight',30,'MinPeakDistance',MPD);

 Flexion = (SbjH_aX(locs_MAX_F)-SbjH_aX(locs_MIN_F));
 Flexion = transpose(Flexion);
 mmmF = [min(Flexion),max(Flexion),mean(Flexion)];
 
 if (SbjH_aX(locs_MAX_F(1)) < 0 && SbjT_aX(locs_MAX_F(1)) > 0) || ...
         ((SbjH_aX(locs_MAX_F(1)) > 0 && SbjT_aX(locs_MAX_F(1)) < 0))
     SbjT_aX = -SbjT_aX;     
 end
     
  SbjH_aXC = SbjH_aX - SbjT_aX;
  
 MPD = int16(length(SbjH_aXC)/3*0.75);
 [~,locs_MAX_FC] = findpeaks(SbjH_aXC,'MinPeakHeight',30,'MinPeakDistance',MPD);
aXC_inv = -SbjH_aXC;
[~,locs_MIN_FC] = findpeaks(aXC_inv,'MinPeakHeight',30,'MinPeakDistance',MPD);

 Flexion_Comp = SbjH_aXC(locs_MAX_FC)-SbjH_aXC(locs_MIN_FC);
 Flexion_Comp = transpose(Flexion_Comp);
 mmmF_Comp = [min(Flexion_Comp),max(Flexion_Comp),mean(Flexion_Comp)];

%%
figure(2)
hold on 
plot(SbjH_aX)
plot(SbjT_aX)
plot(SbjH_aXC)
stem(locs_MAX_F,SbjH_aX(locs_MAX_F),'r.')
text(locs_MAX_F + 20,SbjH_aX(locs_MAX_F),num2str(SbjH_aX(locs_MAX_F)))
stem(locs_MIN_F,SbjH_aX(locs_MIN_F),'r.')
text(locs_MIN_F + 20,SbjH_aX(locs_MIN_F),num2str(SbjH_aX(locs_MIN_F)))
stem(locs_MAX_F,SbjT_aX(locs_MAX_F),'b.')
text(locs_MAX_F + 20,SbjT_aX(locs_MAX_F),num2str(SbjT_aX(locs_MAX_F)))
stem(locs_MIN_F,SbjT_aX(locs_MIN_F),'b.')
text(locs_MIN_F + 20,SbjT_aX(locs_MIN_F),num2str(SbjT_aX(locs_MIN_F)))
grid on
ax = gca;
ax.XAxis.TickLabels = int8(ax.XAxis.TickValues/90);
yline(0, 'm--', 'LineWidth', 1);
title('Flexoextensión')
legend("HMD","Tracker","F Comp","Vel","Vel Comp")
xlabel('Segundos')
ylabel('Grados')
set(figure(2),'WindowState', 'maximized')

%%
 
 Flexion_TOTAL = [SBJ,Flexion,mmmF,Flexion_Comp,mmmF_Comp,...
     vFMax,vFMin,vFm,vFTMax,vFTMin,vFCMax,vFCMin,vFCm];
 writematrix(Flexion_TOTAL,'Results_Flexion.csv','WriteMode','append');
 
  
%% Rotation

figure('WindowState', 'maximized');
plot(SbjH.aY)
yline(0, 'm--', 'LineWidth', 1);

[xR1,~] = ginput(2);

for i = 1:2 
    xR1(i) = int32(xR1(i));
end

close figure 1
%%
SbjH_aY = SbjH.aY(xR1(1):xR1(2));
SbjT_aY = SbjT.aY(xR1(1):xR1(2));

SbjH_aYp = mean(SbjH_aY(1:9));
SbjT_aYp = mean(SbjT_aY(1:9));

SbjH_aY = SbjH_aY - SbjH_aYp;
SbjT_aY = SbjT_aY - SbjT_aYp;

SbjH_aY = wrapTo180(SbjH_aY);
SbjT_aY = wrapTo180(SbjT_aY);

SbjH_aY = filtfilt(b,a,SbjH_aY);
SbjT_aY = filtfilt(bT,aT,SbjT_aY);

figure('WindowState', 'maximized');
plot(SbjH_aY)
yline(0, 'm--', 'LineWidth', 1);

[xR2,~] = ginput(6);

for i = 1:6 
    xR2(i) = int32(xR2(i));
end

RHRep1 = SbjH_aY(xR2(1):xR2(2));
RHRep2 = SbjH_aY(xR2(3):xR2(4));
RHRep3 = SbjH_aY(xR2(5):xR2(6));

RTRep1 = SbjT_aY(xR2(1):xR2(2));
RTRep2 = SbjT_aY(xR2(3):xR2(4));
RTRep3 = SbjT_aY(xR2(5):xR2(6));

SbjH_aY = zeros(length(RHRep1)+length(RHRep2)+length(RHRep3),1);
SbjT_aY = zeros(length(RHRep1)+length(RHRep2)+length(RHRep3),1);

SbjH_aY(1:length(RHRep1),1) = RHRep1;
SbjH_aY(length(RHRep1)+1:length(RHRep1)+length(RHRep2),1) = RHRep2;
SbjH_aY(length(RHRep1)+length(RHRep2)+1:length(RHRep1)+length(RHRep2)+length(RHRep3),1) = RHRep3;

SbjT_aY(1:length(RHRep1),1) = RTRep1;
SbjT_aY(length(RHRep1)+1:length(RHRep1)+length(RHRep2),1) = RTRep2;
SbjT_aY(length(RHRep1)+length(RHRep2)+1:length(RHRep1)+length(RHRep2)+length(RHRep3),1) = RTRep3;

close figure 1


%%
MPD = int16(length(SbjH_aY)/3*0.75);

[~,locs_MAX_R] = findpeaks(SbjH_aY,'MinPeakHeight',30,'MinPeakDistance',MPD);

aY_inv = -SbjH_aY;
[~,locs_MIN_R] = findpeaks(aY_inv,'MinPeakHeight',30,'MinPeakDistance',MPD);

 Rotation = (SbjH_aY(locs_MAX_R)-SbjH_aY(locs_MIN_R));
 Rotation = transpose(Rotation);
 mmmR = [min(Rotation),max(Rotation),mean(Rotation)];
 
 if (SbjH_aY(locs_MAX_R(1)) < 0 && SbjT_aY(locs_MAX_R(1)) > 0) || ...
         ((SbjH_aY(locs_MAX_R(1)) > 0 && SbjT_aY(locs_MAX_R(1)) < 0))
    SbjT_aY = -SbjT_aY;
 end
 
 SbjH_aYC = SbjH_aY - SbjT_aY;
 
 MPD = int16(length(SbjH_aYC)/3*0.75);
 [~,locs_MAX_RC] = findpeaks(SbjH_aYC,'MinPeakHeight',20,'MinPeakDistance',MPD);
aYC_inv = -SbjH_aYC;
[~,locs_MIN_RC] = findpeaks(aYC_inv,'MinPeakHeight',20,'MinPeakDistance',MPD);

 Rotation_Comp = SbjH_aYC(locs_MAX_RC)-SbjH_aYC(locs_MIN_RC);
 Rotation_Comp = transpose(Rotation_Comp);
 mmmR_Comp = [min(Rotation_Comp),max(Rotation_Comp),mean(Rotation_Comp)];

 %%
figure(3)
hold on 
plot(SbjH_aY)
plot(SbjT_aY)
plot(SbjH_aYC)
plot(vR)
plot(vRC)
stem(locs_MAX_R,SbjH_aY(locs_MAX_R),'r.')
text(locs_MAX_R + 20,SbjH_aY(locs_MAX_R),num2str(SbjH_aY(locs_MAX_R)))
stem(locs_MIN_R,SbjH_aY(locs_MIN_R),'r.')
text(locs_MIN_R + 20,SbjH_aY(locs_MIN_R),num2str(SbjH_aY(locs_MIN_R)))
stem(locs_MAX_R,SbjT_aY(locs_MAX_R),'b.')
text(locs_MAX_R + 20,SbjT_aY(locs_MAX_R),num2str(SbjT_aY(locs_MAX_R)))
stem(locs_MIN_R,SbjT_aY(locs_MIN_R),'b.')
text(locs_MIN_R + 20,SbjT_aY(locs_MIN_R),num2str(SbjT_aY(locs_MIN_R)))
grid on
ax = gca;
ax.XAxis.TickLabels = int8(ax.XAxis.TickValues/90);
yline(0, 'm--', 'LineWidth', 1);
title('Rotación')
legend("HMD","Tracker","R Comp","Vel","Vel Comp")
xlabel('Segundos')
ylabel('Grados')
set(figure(3),'WindowState', 'maximized')
 
 %%
 Rotation_TOTAL = [SBJ,Rotation,mmmR,Rotation_Comp,mmmR_Comp,...
     vRMax,vRMin,vRm,vRTMax,vRTMin,vRCMax,vRCMin,vRCm];
 writematrix(Rotation_TOTAL,'Results_Rotation.csv','WriteMode','append');
 
%% Lateral FLexion 
%%
figure('WindowState', 'maximized');
plot(SbjH.aZ)
yline(0, 'm--', 'LineWidth', 1);

[xFL1,~] = ginput(2);

for i = 1:2 
    xFL1(i) = int32(xFL1(i));
end

close figure 1

%%
SbjH_aZ = SbjH.aZ(xFL1(1):xFL1(2));
SbjT_aZ = SbjT.aZ(xFL1(1):xFL1(2));

SbjH_aZp = mean(SbjH_aZ(1:9));
SbjT_aZp = mean(SbjT_aZ(1:9));

SbjH_aZ = SbjH_aZ - SbjH_aZp;
SbjT_aZ = SbjT_aZ - SbjT_aZp;

SbjH_aZ = wrapTo180(SbjH_aZ);
SbjT_aZ = wrapTo180(SbjT_aZ);

SbjH_aZ = filtfilt(b,a,SbjH_aZ);
SbjT_aZ = filtfilt(bT,aT,SbjT_aZ);

figure('WindowState', 'maximized');
plot(SbjH_aZ)
yline(0, 'm--', 'LineWidth', 1);

[xFL2,~] = ginput(6);

for i = 1:6 
    xFL2(i) = int32(xFL2(i));
end

FLHRep1 = SbjH_aZ(xFL2(1):xFL2(2));
FLHRep2 = SbjH_aZ(xFL2(3):xFL2(4));
FLHRep3 = SbjH_aZ(xFL2(5):xFL2(6));

FLTRep1 = SbjT_aZ(xFL2(1):xFL2(2));
FLTRep2 = SbjT_aZ(xFL2(3):xFL2(4));
FLTRep3 = SbjT_aZ(xFL2(5):xFL2(6));

SbjH_aZ = zeros(length(FLHRep1)+length(FLHRep2)+length(FLHRep3),1);
SbjT_aZ = zeros(length(FLHRep1)+length(FLHRep2)+length(FLHRep3),1);

SbjH_aZ(1:length(FLHRep1),1) = FLHRep1;
SbjH_aZ(length(FLHRep1)+1:length(FLHRep1)+length(FLHRep2),1) = FLHRep2;
SbjH_aZ(length(FLHRep1)+length(FLHRep2)+1:length(FLHRep1)+length(FLHRep2)+length(FLHRep3),1) = FLHRep3;

SbjT_aZ(1:length(FLHRep1),1) = FLTRep1;
SbjT_aZ(length(FLHRep1)+1:length(FLHRep1)+length(FLHRep2),1) = FLTRep2;
SbjT_aZ(length(FLHRep1)+length(FLHRep2)+1:length(FLHRep1)+length(FLHRep2)+length(FLHRep3),1) = FLTRep3;

close figure 1

%%

MPD = int16(length(SbjH_aZ)/3*0.75);

[~,locs_MAX_FL] = findpeaks(SbjH_aZ,'MinPeakHeight',20,'MinPeakDistance',MPD);

aZ_inv = -SbjH_aZ;
[~,locs_MIN_FL] = findpeaks(aZ_inv,'MinPeakHeight',20,'MinPeakDistance',MPD);

 FLexionLat = (SbjH_aZ(locs_MAX_FL)-SbjH_aZ(locs_MIN_FL));
 FLexionLat = transpose(FLexionLat);
 mmmFL = [min(FLexionLat),max(FLexionLat),mean(FLexionLat)];

 if (SbjH_aZ(locs_MAX_FL(1)) < 0 && SbjT_aZ(locs_MAX_FL(1)) > 0) || ((SbjH_aZ(locs_MAX_FL(1)) > 0 && SbjT_aZ(locs_MAX_FL(1)) < 0))
    SbjT_aZ = -SbjT_aZ;
 end
 
 SbjH_aZC = SbjH_aZ - SbjT_aZ;
 
 MPD = int16(length(SbjH_aZC)/3*0.75);
 [~,locs_MAX_FLC] = findpeaks(SbjH_aZC,'MinPeakHeight',20,'MinPeakDistance',MPD);
aZC_inv = -SbjH_aZC;
[~,locs_MIN_FLC] = findpeaks(aZC_inv,'MinPeakHeight',20,'MinPeakDistance',MPD);

 FLexionLat_Comp = SbjH_aZC(locs_MAX_FLC)-SbjH_aZC(locs_MIN_FLC);
 FLexionLat_Comp = transpose(FLexionLat_Comp);
 mmmFL_Comp = [min(FLexionLat_Comp),max(FLexionLat_Comp),mean(FLexionLat_Comp)];

%%

figure(4)
hold on 
plot(SbjH_aZ)
plot(SbjT_aZ)
plot(SbjH_aZC)
stem(locs_MAX_FL,SbjH_aZ(locs_MAX_FL),'r.')
text(locs_MAX_FL + 20,SbjH_aZ(locs_MAX_FL),num2str(SbjH_aZ(locs_MAX_FL)))
stem(locs_MIN_FL,SbjH_aZ(locs_MIN_FL),'r.')
text(locs_MIN_FL + 20,SbjH_aZ(locs_MIN_FL),num2str(SbjH_aZ(locs_MIN_FL)))
stem(locs_MAX_FL,SbjT_aZ(locs_MAX_FL),'b.')
text(locs_MAX_FL + 20,SbjT_aZ(locs_MAX_FL),num2str(SbjT_aZ(locs_MAX_FL)))
stem(locs_MIN_FL,SbjT_aZ(locs_MIN_FL),'b.')
text(locs_MIN_FL + 20,SbjT_aZ(locs_MIN_FL),num2str(SbjT_aZ(locs_MIN_FL)))
grid on
ax = gca;
ax.XAxis.TickLabels = int8(ax.XAxis.TickValues/90);
yline(0, 'm--', 'LineWidth', 1);
title('Inclinación Lateral')
legend("HMD","Tracker","FL Comp","Vel","Vel Comp")
xlabel('Segundos')
ylabel('Grados')
set(figure(4),'WindowState', 'maximized')

 %%
 FLexionLat_TOTAL = [SBJ,FLexionLat,mmmFL,FLexionLat_Comp,mmmFL_Comp,...
     vFLMax,vFLMin,vFLm,vFLTMax,vFLTMin,vFLCMax,vFLCMin,vFLCm];
 writematrix(FLexionLat_TOTAL,'Results_LatFlexion.csv','WriteMode','append');
 
  savefile = Res_Folder+"/"+SBJ+".mat";
  save(savefile);