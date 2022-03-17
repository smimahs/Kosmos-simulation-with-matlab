function [c,ceq] = constrians1(x)
    global Nopt VR Vlost C;
	for Nopt = 2
        mu_e1 = x(1);
        mu_e2 = x(2);
        nv1 = x(3);
        nv2 = x(4);
        
        ceq = VR + C(1) .* log(mu_e1) + C(2) .* log(mu_e2) + Vlost;
    end
    
     c = [];
end