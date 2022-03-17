function fitness=FitEval2(x)
global Nopt a1 a2 b1 b2 Pv1 Pv2 m_upper_stage g0
switch Nopt
    case 2
        mu_e1=x(1);
        mu_e2=x(2);
        fitness=((m_upper_stage.*(1-a1).*(1-a2))+(b2.*Pv2.*1000.*(1-a1)./g0)+(b1.*Pv1.*1000.*(mu_e2-a2)./g0))./((mu_e1-a1).*(mu_e2-a2));
end