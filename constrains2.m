function [c,ceq]=constrains2(x)
global VR Vlost Nopt a1 b1 C1 a2 b2 C2 Pv1 Pv2 m_upper_stage g0 nv1_min nv1_Max nvi_min nvi_Max
switch Nopt
    case 2
        mu_e1=x(1);
        mu_e2=x(2);
        ceq=VR+C1.*log(mu_e1)+C2.*log(mu_e2)+Vlost;
        M01=((m_upper_stage.*(1-a1).*(1-a2))+(b2.*Pv2.*1000.*(1-a1)./g0)+(b1.*Pv1.*1000.*(mu_e2-a2)./g0))./((mu_e1-a1).*(mu_e2-a2));
        nv1=Pv1*1000./(M01*g0);
        mu_PL1=(mu_e1-a1-(b1*nv1))/(1-a1);
        M02=mu_PL1*M01;
        nv2=Pv2*1000./(M02*g0);
        c=[-nv1+nv1_min
           -nv2+nvi_min
           nv1-nv1_Max
           nv2-nvi_Max];
end