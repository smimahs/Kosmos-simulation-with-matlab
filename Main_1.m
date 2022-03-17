
%% ----- sizing - weight & thrust of stage calculation -----
global i Nopt a b C asigma acs apc Ispv gamaps g0 M01 m_upper_stage mu_e_min  ...
    mu_e_max1 mu_e_maxi nv1_min nvi_min nv1_max nvi_max min_delta_Vlost_allowable ...
    min_delta_Vchar_allowable min_delta_Mass_allowable ii jj j a1 b1 C1...
    a2 b2 C2 Datapropultion max_O_K_row max_O_H_row Pv1 Pv2 Ne1 Ne2 Di_Max...
    M02 Fuel_kind Ispv1 gamaps1 apc1 Ispv2 gamaps2 apc2 apc3 mcs mp1 mp2...
    mpc1 mps1 msigma1 mpc2 mps2 msigma2 Ispv3 gamaps3 Sm mdot1 mdot2...
    t0 t1 t2 tend AZ_real Vearth Vlost Ve_perigee Hp;

%% .................... Sizing - Weight & thrust of stages calculation ..............

i = 1;
while i<=Nopt

    Ispv(i)=Ispv3;
    gamaps(i)=gamaps;
    apc(i)=apc3;


a(i)=(apc(i)+asigma)./(1+apc(i));

if i==Nopt 
    a(i)=(apc(i)+asigma+acs)./(1+apc(i));
end

b(i)=gamaps(i)./(1+apc(i));
C(i)=Ispv(i).*g0;


i=i+1;
end 

%% ----- GAs boundry condition -----

mu_e_min = 0.01;
mu_e_max1 = 0.5;
mu_e_maxi = 0.4;
nv1_min = 1.2;
nvi_min = 0.8;
nv1_max = 20;
nvi_max = 10;

disp('----- GA optimization -----');
[X,FVAL,REASON,OUTPUT,POPULATION,SCORES] = GA1;

disp('----- End of GA optimization -----');
if FVAL == 10
    disp('the value of fitness function is imaginery, try again!');
end

mu_PLmax = exp(-FVAL);
fprintf('mu_PLmax= %12.5f\n',mu_PLmax);

M01 = m_upper_stage/mu_PLmax;
fprintf('M01(kg)= %12.5f\n',M01);
switch Nopt
    case 2
        mu_e1 = X(1);
        mu_e2 = X(2);
        nv1 = X(3);
        nv2 = X(4);
        mu_PL1 = (mu_e1 - a(1) - (b(1)*nv1))/(1-a(1));
        M02 = mu_PL1*M01;
        Pv1 = nv1*M01*g0/1000;
        Pv2 = nv2*M02*g0/1000;
%         fprintf('mu_PL1= %12.5f\n',mu_PL1);
%         fprintf('M02= %12.5f\n',M02);
        fprintf('mu_e1= %12.5f\n',mu_e1);
        fprintf('mu_e2= %12.5f\n',mu_e2);
        fprintf('nv1= %12.5f\n',nv1);
        fprintf('nv2= %12.5f\n',nv2);
        fprintf('PV1- Vaccum thrust (KN)= %12.5f\n',Pv1);
        fprintf('PV2- Second stage Vaccum thrust (KN)= %12.5f\n',Pv2);
end

%% ------------------- propulsion system selection ------------------------
switch Nopt
    case 2
        acs1=0;
        acs2=acs;
        asigma1=asigma;
        asigma2=asigma;
end
iteration=0;
NO_of_iteration_str=1;
NO_of_iteration_lost=1;
Error_Vlost=1;
Error_Vchar=1;

while Error_Vlost>min_delta_Vlost_allowable || Error_Vchar>min_delta_Vchar_allowable
    Error_M01=1;
    while Error_M01>min_delta_Mass_allowable
        clear deltaT1 deltaT2
        i=1; ii=1; jj=1; j=1;
        [Engine_type, Propellant]=Propultion_database(1);
        [rDatapropultion, cDatapropultion]=size(Datapropultion);
        
        disp('--------------------- Propultion selection & re-calculation ------ ')
        disp(' ')
        switch Nopt
            case 2
                if Fuel_kind(1)==1
                    rDatapropultion1=1;
                    rDatapropultion2=max_O_K_row;
                elseif Fuel_kind(1)==2
                    rDatapropultion1=max_O_K_row+1;
                    rDatapropultion2=max_O_H_row;
                else
                    rDatapropultion1=max_O_H_row+1;
                    rDatapropultion2=rDatapropultion;
                end
                ii=1;
                for i=rDatapropultion1:1:rDatapropultion2
                    Ne1(ii)=Pv1/Datapropultion(i,2);
                    Ne1(ii)=ceil(Ne1(ii));
                    if (Ne1(ii)*Datapropultion(i,8))<Di_Max
                        Pv1_new(ii)=Ne1(ii)*Datapropultion(i,2);
                        deltaT1(ii)=Pv1_new(ii)-Pv1;
                    else
                        Pv1_new(ii)=Ne1(ii)*Datapropultion(i,2);
                        deltaT1(ii)=inf;
                    end
                    ii=ii+1;
                end
                [deltaT, i]=min(deltaT1);
                Pv1=Pv1_new(i);
                ii=i;
                if Fuel_kind(1)==2
                    i=i+max_O_K_row;
                elseif Fuel_kind(1)==3
                    i=i+max_O_H_row;
                end
                nv1_new=(Pv1*1000)/(M01*g0);
                delta_nv1=abs(nv1_new-nv1);
                Ispv1_new=Datapropultion(i,3);
                Ispv1=Ispv1_new;
                gamaps1_new=Datapropultion(i,10);
                gamaps1=gamaps1_new;
                switch iteration
                    case 0
                        if Datapropultion(i,1)<=max_O_K_row
                            apc_1=apc1;
                        elseif Datapropultion(i,1)>max_O_K_row && Datapropultion(i,1)<=max_O_H_row
                            apc_1=apc2;
                        else
                            apc_1=apc3;
                        end
                    case 1
                        disp('')
                end
                [Engine_type1, Propellant1]=Propultion_database(i);
                if Fuel_kind(2)==1
                    rDatapropultion1=1;
                    rDatapropultion2=max_O_K_row;
                elseif Fuel_kind(2)==2
                    rDatapropultion1=max_O_K_row+1;
                    rDatapropultion2=max_O_H_row;
                else
                    rDatapropultion1=max_O_H_row+1;
                    rDatapropultion2=rDatapropultion;
                end
                jj=1;
                for j=rDatapropultion1:1:rDatapropultion2
                    Ne2(jj)=Pv2/Datapropultion(j,2);
                    Ne2(jj)=ceil(Ne2(jj));
                    if (Ne2(jj)*Datapropultion(j,8))<Di_Max
                        Pv2_new(jj)=Ne2(jj)*Datapropultion(j,2);
                        deltaT2(jj)=Pv2_new(jj)-Pv2;
                    else
                        Pv2_new(jj)=Ne2(jj)*Datapropultion(j,2);
                        deltaT2(jj)=inf;
                    end
                    jj=jj+1;
                end
                [deltaT, j]=min(deltaT2);
                Pv2=Pv2_new(j);
                jj=j;
                if Fuel_kind(2)==2
                    j=j+max_O_K_row;
                elseif Fuel_kind(2)==3
                    j=j+max_O_H_row;
                end
                nv2_new=(Pv2*1000)./(M02*g0);
                delta_nv2=abs(nv2_new-nv2);
                delta_nv=delta_nv1+delta_nv2;
                Ispv2_new=Datapropultion(j,3);
                Ispv2=Ispv2_new;
                gamaps2_new=Datapropultion(j,10);
                gamaps2=gamaps2_new;
                switch iteration
                    case 0
                        if Datapropultion(i,1)<=max_O_K_row
                            apc_2=apc1;
                        elseif Datapropultion(i,1)>max_O_K_row && Datapropultion(i,1)<=max_O_H_row
                            apc_2=apc2;
                        else
                            apc_2=apc3;
                        end
                    case 1
                        disp('')
                end
                [Engine_type2, Propellant2]=Propultion_database(j);
                a1=(apc_1+asigma1+acs1)./(1+apc_1);
                b1=gamaps1./(1+apc_1);
                C1=Ispv1.*g0;
                a2=(apc_2+asigma2+acs2)./(1+apc_2);
                b2=gamaps2./(1+apc_2);
                C2=Ispv2.*g0;
        end
        fprintf('  delta_nv = %12.5f \n\n',delta_nv);

        %% --------------------------- resizing ---------------------------------
        [results2,FVAL,REASON,OUTPUT,POPULATION,SCORES]=GA2;
        M01=FVAL;
        mu_PLmax=m_upper_stage/M01;
        switch Nopt
            case 2
                mu_e1=results2(1);
                nv1=Pv1*1000./(M01*g0);
                mu_PL1=(mu_e1-a1-(b1*nv1))/(1-a1);
                mpc1=apc_1*(1-mu_e1)*M01;
                mp1=mpc1/apc_1;
                mps1=gamaps1*Pv1*1000/g0;
                msigma1=asigma1*(1-mu_PL1)*M01;
                mcs1=acs1*(1-mu_PL1)*M01;
                me1=mpc1+mps1+msigma1+mcs1;
                m01=me1+mp1;
                
                mu_e2=results2(2);
                M02=M01*mu_PL1;
                nv2=Pv2*1000./(M02*g0);
                mu_PL2=(mu_e2-a2-(b2*nv2))/(1-a2);
                mpc2=apc_2*(1-mu_e2)*M02;
                mp2=mpc2/apc_2;
                mps2=gamaps2*Pv2*1000/g0;
                msigma2=asigma2*(1-mu_PL2)*M02;
                mcs2=acs2*(1-mu_PL2)*M02;
                mcs=mcs2;
                me2=mpc2+mps2+msigma2+mcs2;
                m02=me2+mp2;
        end
        fprintf('  mu_PLmax = %12.5f \n\n',mu_PLmax);
        fprintf('  M01 (Kg) = %12.5f \n\n',M01);

        switch Nopt
            case 2
                fprintf('  mu_e1 = %12.5f \n\n',mu_e1);
                fprintf('  mu_e2 = %12.5f \n\n',mu_e2);
                fprintf('  nv1 = %12.5f \n\n',nv1);
                fprintf('  nv2 = %12.5f \n\n',nv2);
                fprintf('  First stage gross mass (Kg) = %12.5f \n\n',m01);
                fprintf('  First stage propellant mass (Kg) = %12.5f \n\n',mp1);
                fprintf('  Second stage gross mass (Kg) = %12.5f \n\n',m02);
                fprintf('  Second stage propellant mass (Kg) = %12.5f \n\n',mp2);
                fprintf('  Vaccum thrust of First stage engine or engines (KN) = %12.5f \n\n',Pv1);
                fprintf('  Number of First stage engines = %12.5f \n\n',Ne1(ii));
                fprintf('  First stage Engine type = %s \n\n',Engine_type1);
                fprintf('  First stage prpellant type = %s \n\n',Propellant1);
                fprintf('  Vaccum thrust of Second stage engine or engines (KN) = %12.5f \n\n',Pv2);
                fprintf('  Number of Second stage engines = %12.5f \n\n',Ne2(jj));
                fprintf('  Second stage Engine type = %s \n\n',Engine_type2);
                fprintf('  Second stage prpellant type = %s \n\n',Propellant2);
        end


    %% ------------- simulation of motion -----------------
    disp('------------- simulation of motion -----------------');
    Sm = pi*Di_Max^2/4;
    switch Nopt
        case 2
            mdot1 = (Pv1*1000) ./ (g0.*Ispv1);
            t1 = mp1 ./ mdot1;
            mdot2 = (Pv2*1000) ./ (g0.*Ispv2);
            t2 = mp2 ./ mdot2;

            tend = t1+t2;
    end
    t0 = 10;
    end_try = 1;
    while end_try ~= 0
        end_try = input('for end the process press 0 and press any other key for continue: ');
        disp('');
        if end_try == 0
            min_delta_Vlost_allowable = 1;
            min_delta_Vchar_allowable = 1;
            min_delta_Mass_allowable = 1;
            break;
        end
        clear tt VV VCHARR hh cl cd Mach11 alpha1 theta1 gama1;
        switch Nopt
            case 2
                theta_s = input('insert the pitch angle while first and second stage have been seperated(degree)= ');
                disp('');
                theta_s = theta_s*pi/180;
        end
        [tt,VV,VCHARR,hh,cl,cd,Mach11,alpha1,theta1,gama1]=equation_of_motion(theta_s);
        VF = sqrt(VV.^2 + (Vearth*1000).^2 + (2.*VV.*(Vearth*1000).*cos(pi/2-AZ_real)));
        VLOST = VCHARR-VV(end);
        switch Nopt
            case 2
                VCHARold = -C1.*log(mu_e1)-C2.*log(mu_e2);
        end

        fprintf('Calculate lost velocity(km/s) = %12.5f\n\n',VLOST/1000);
        fprintf('Guessed lost velocity(km/s) = %12.5f\n\n',Vlost/1000);
        fprintf(' new Calculate charesterestic velocity(km/s) = %12.5f\n\n',VCHARR/1000);
        fprintf('final velocity(km/s) = %12.5f\n\n',VF(end)/1000);
        fprintf('orbit velocity in perigee(km/s) = %12.5f\n\n',Ve_perigee);
        fprintf('Reached height(km) = %12.5f\n\n',hh(end)/1000);
        fprintf('Perigee height of destination orbit(km) = %12.5f\n\n',Hp);
        fprintf('------------------------------------------------------- \n\n');

    end
    figure(3);
    subplot(2,3,1);
    plot(tt,VV);
    xlabel('t(s)');
    ylabel('V related to earth(m/s)');
    subplot(2,3,2);
    plot(tt,VF);
    xlabel('t(s)');
    ylabel('V related fixed refrence(m/s)');
    subplot(2,3,3);
    plot(tt,hh/1000);
    xlabel('t(s)');
    ylabel('h from local horizantal(km)');
    subplot(2,3,4);
    plot(tt,cl);
    xlabel('t(s)');
    ylabel('CL');
    subplot(2,3,5);
    plot(tt,cd);
    xlabel('t(s)');
    ylabel('CD');
    subplot(2,3,6);
    plot(tt,Mach11);
    xlabel('t(s)');
    ylabel('Mach');
    figure(4);
    subplot(3,1,1);
    plot(tt,alpha1);
    xlabel('t(s)');
    ylabel('angle of attack');
    subplot(3,1,2);
    plot(tt,theta1);
    xlabel('t(s)');
    ylabel('pitch angle');
    subplot(3,1,3);
    plot(tt,gama1);
    xlabel('t(s)');
    ylabel('path angle');
    end
 
end      
        
    

