function [X,FVAL,REASON,OUTPUT,POPULATION,SCORES]=GA1()
    global mu_e_min mu_e_max1  mu_e_maxi  nv1_min  nvi_min  nv  Nopt


    fitnessFunction = @FitEval;
    
    nvars = fix(Nopt*2);

    Aineq = [];
    Bineq = [];

    Aeq = [];
    Beq = [];
    options = gaoptimset;

    for Nopt=2
        LB = [mu_e_min mu_e_min nv1_min nvi_min];
        UB = [mu_e_max1 mu_e_maxi nv nv];
        options = gaoptimset(options,'PopInitRange',[mu_e_min mu_e_min nv1_min nvi_min;mu_e_max1 mu_e_maxi nv nv]);
        options = gaoptimset(options,'InitialPopulation',(LB+UB)./2);
    end

    non1confunction = @constrians1;
    %%GA
    options = gaoptimset(options,'PopulationSize',100);
    options = gaoptimset(options,'Generations',100);
    options = gaoptimset(options,'StallGenLimit',1000);
    options = gaoptimset(options,'CrossoverFraction',0.6);
    options = gaoptimset(options,'CrossoverFcn',{ @crossoverintermediate 1 });
    options = gaoptimset(options,'MutationFcn',@mutationadaptfeasible);
    options = gaoptimset(options,'Display','diagnose');
    % options = gaoptimset(options,'PlotFcn',{@gaplotbestf});
    [X,FVAL,REASON,OUTPUT,POPULATION,SCORES] = ga(fitnessFunction,nvars,Aineq,Bineq,Aeq,Beq,LB,UB,non1confunction,options);
end
