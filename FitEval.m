function fitness = FitEval(x)
    global Nopt a b;
    for Nopt = 2
        mu_e1 = x(1);
        mu_e2 = x(2);
        nv1 = x(3);
        nv2 = x(4);
        fitness = -log((mu_e1)-a(1)-b(1).*nv1)./(1 - a(1)) - log((mu_e2-a(2)-b(2).*nv2)./(1-a(2)));
    end
    % if fitness was unknown
    if imag(fitness) ~= 0
        fitness = 10;
    end
end