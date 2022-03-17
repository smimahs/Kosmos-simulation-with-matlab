function [Engine_type Propellant]=Propultion_database(x)
global Datapropultion max_O_K_row max_O_H_row
switch x
    case 1
        Engine_type='RD 191';
        Propellant='O-K';
    case 2
        Engine_type='RD 0124 M';
        Propellant='O-K';
    case 3
        Engine_type='RS-27A';
        Propellant='O-K';
    case 4
        Engine_type='RD-180';
        Propellant='O-K';
    case 5
        Engine_type='HM7B';
        Propellant='O-H';
    case 6
        Engine_type='Vulcain';
        Propellant='O-H';
    case 7
        Engine_type='RL10B-2';
        Propellant='O-H';
    case 8
        Engine_type='RD-216/11D614';
        Propellant='UDMH-N2O4';
    case 9
        Engine_type='11D49';
        Propellant='UDMH-N2O4';
end
               %1-NO	2-Thrust(vac)-KN	3-Isp(vac)-s    4-Mixtureratio(O/F)     5-Engine mass(Kg)     6-Engine length(m)    %7-Nozzele length(m)     8-Engine diameter(m)     9-Sa(m^2)   %10-gamaps(Pv)    11-pox(Kg/m^3)	12-pF(Kg/m^3)
Datapropultion=[1	2095	337.5	2.6     2200	4       2.67	1.45	1.651299639	0.010301671	1141	817.15
                2	294.3	348     2.6     360     2.1     1.4     1.43	1.606060704	0.012       1141	817.15
                3	1085.8	301.7	2.24	1147	3.78	2.52	1.7     2.269800692	0.010362931	1141	817.15
                4	4150	338     2.24	5480	3.56	2.374	3.15	7.793       0.012953928	1141    817.15
                5	62.7	445.1	4.77	155     2.013	1.342	0.992	0.772882058	0.024251196	1141	67.8
                6	1114	430     5.3     1475	3       2       1.76	2.432849351	0.012989004	1141	67.8
                7	110     462.4	5.5     301     4.14	2.76	2.21	3.83596317	0.026843727	1141	67.8
                8	1745	291.3	2.5     1350	2.2     1.47	2.26	4.011499659	0.007589398	1450	793
                9	157     303     2.65	185     1.78	1.187	1.92	2.89529179	0.011559554	1450	793];

max_O_K_row=4;
max_O_H_row=7;