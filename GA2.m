function [X,FVAL,REASON,OUTPUT,POPULATION,SCORES] =  GA2
global nv Nopt mu_e_min mu_e_max1 mu_e_maxi nv1_min nvi_min
%%   This is an auto generated M file to do optimization with the Genetic Algorithm

 %%                                Fitness function
fitnessFunction = @FitEval2;     
 %%                               Number of Variables
nvars = Nopt*2 ;     

%%  
%------------------------------ Linear inequality constraints-------------
Aineq = [];
Bineq = [];
%------------------------------ Linear equality constraints---------------
Aeq = [];
Beq = [];
%------------------------------ Start with default options ---------------
options = gaoptimset;

for Nopt=2
    
        LB = [mu_e_min  mu_e_min  nv1_min  nvi_min ];
        UB = [mu_e_max1  mu_e_maxi  nv  nv ];
        options = gaoptimset(options,'PopInitRange' ,[mu_e_min  mu_e_min  nv1_min  nvi_min ; mu_e_max1  mu_e_maxi  nv  nv ]);
        options = gaoptimset(options,'InitialPopulation' ,(LB+UB)./2);
end
% ----------------------------Nonlinear constraints-----------------------
nonlconFunction = @constrains2;

%% ---------------------------Modify some parameters---------------------
options = gaoptimset(options,'PopulationSize' ,100);
options = gaoptimset(options,'Generations' ,100);
options = gaoptimset(options,'StallTimeLimit' ,1000);
options = gaoptimset(options,'CrossoverFraction' ,0.6);
options = gaoptimset(options,'CrossoverFcn' ,{ @crossoverintermediate 1  });
options = gaoptimset(options,'MutationFcn' ,@mutationadaptfeasible);
options = gaoptimset(options,'Display' ,'iter');
% options = gaoptimset(options,'PlotFcns' ,{ @gaplotbestf });
%% ----------------------------------Run GA-------------------------------
[X,FVAL,REASON,OUTPUT,POPULATION,SCORES] = ga(fitnessFunction,nvars,Aineq,Bineq,Aeq,Beq,LB,UB,nonlconFunction,options);