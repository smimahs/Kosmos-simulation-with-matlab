%% Shamim Sanisales
%% session1
clc;
clear all;
close all;

global  g0 fM R wE h0 phi Hp Ha inc Ve_perigee Vearth AZ VR khi AZ_real Ispv...
    gamaps apc asigma acs nv Vlost_percentage a b C Vlost Vbarchar mu_PL Nopt mPL...
    HPL DPL m_fairing m_upper_stage h_fairing_seperation pcs Di_Max Rn_min ...
    teta_min teta_max Lfairing_D_Max Lfairing_D_min L1_D1_Max2 L1_D1_min2 L2_D2_Max2 L2_D2_min2 ...
    Mach alpha beta h min_delta_Vchar_allowable min_delta_Mass_allowable min_delta_Vlost_allowable ...
    Ispv1 gamaps1 apc1 Ispv2 gamaps2 apc2 apc3 gamaps3 Ispv3 Fuel_kind;


%% ----- Inputs -----
%% ----- Destination orbit info -----
Di_Max = 4;
min_delta_Vlost_allowable = 0.01;
min_delta_Vchar_allowable = 0.01;
min_delta_Mass_allowable = 0.01;

g0 = 9.80665;
fM = 3.9862e5;
R = 6378;
wE = 7.29e-5;
h0 = 0;
phi = 30; %degree
Hp = 250;
Ha = 250;
inc = 55;

%% ----- propaltion & structure inputs -----
Ispv1 = 330; %s UDMH_N2O4 fuel
gamaps1 = 0.01;
apc1 = 0.04; 

Ispv2 = 300; %s UDMH_N2O4 fuel
gamaps2 = 0.02;
apc2 = 0.1; 

Ispv3 = 300; %s UDMH_N2O4 fuel
gamaps3 = 0.01;
apc3 = 0.04; 

asigma = 0.03;

acs = 0.01;
nv = 1.5;

Vlost_percentage = 20/100; % 20%

%% ----- payload specification ----- 

mPL = 1500; % kg
DPL = 2.4;
HPL = 3;
V_PL = 1.2*(pi*DPL^2/4)*HPL; % velocity

m_fairing = mPL*0.15;
m_upper_stage = m_fairing + mPL;

h_fairing_seperation = 100000; %meter

% for 2 stage LV
L1_D1_Max2 = 14;
L1_D1_min2 = 2;
L2_D2_Max2 = 5.5;
L2_D2_min2 = 2;

Mach = 0.5;
alpha = 0;
beta = 0;
h = 0;
%% ----- Calculation -----
%% ----- destination orbit -----
Ve_perigee = sqrt(2*fM*((1/(R+Hp)))-(1/(2+R+Hp+Ha)));
fprintf('Ve_perigee(km/s) = %12.5f\n',Ve_perigee);
phi = deg2rad(phi);
inc = deg2rad(inc);
Vearth = R* wE * cos(phi);

AZ = asin(cos(inc)/cos(phi));
%beta = (pi/2) - AZ;

Vorbit = sqrt(2*fM*((1/(R+Hp))-(1/((2*R)+Hp+Ha))));
VR = sqrt((Vearth^2)+ (Vorbit^2)-(2*Vearth*Vorbit*cos((pi/2) - AZ)));

khi = asin((Vearth*sin((pi/2) - AZ))/VR);

AZ_real = AZ - khi;

% fprintf('Vorbit(km/s) = %12.5f\n',Vorbit);
fprintf('VR(km/s) = %12.5f\n',VR);
VR=VR*1000; 

fprintf('AZ Real(degree) = %12.5f\n',rad2deg(AZ_real));

%% ----- Number of stage -----
Ispv = Ispv3;
gamaps = gamaps3;
apc = apc3;

a = (apc + asigma) ./ (1+apc);
b = gamaps ./ (1+apc);
C = Ispv .* g0;

Vlost = VR * Vlost_percentage;
VChar = VR + Vlost;
Vbarchar = VChar/C;

N = 1.5:0.1:20;
mu_PL1=((1./(1-a)).*((exp(-Vbarchar)).^(1./N)-a-b.*nv)).^N;

figure(1);
plot(N,mu_PL1);
xlabel('N');
ylabel('\mu_p');

mu_PL = max(mu_PL1);
Nmax = interp1(mu_PL1,N,mu_PL);
N = 1.5:0.1:Nmax;
mu_PL1=((1./(1-a)).*((exp(-Vbarchar)).^(1./N)-a-b.*nv)).^N;
Nopt=interp1(mu_PL1,N,0.8*mu_PL);

title(['the opt number of stage is ' num2str(Nopt)]);
fprintf('the opt number of stage is %12.5f\n',(Nopt));


Nopt = menu('number of stage',...
                '  one  ','  two  ');
            
counter = 1;
while counter <= Nopt
    Fuel_kind(counter) = menu(['fuel kind (stage ' num2str(counter) ')'],'o2-kerosine','o2-H2','UDMH-N2o4');
    counter = counter+1;
end
Main_1
% main_i



