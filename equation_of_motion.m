function [tt,VV,VCHARR,hh,cl,cd,Mach11,alpha1,theta1,gama1]=equation_of_motion(theta_s)

global R h0 tend Nopt t1 t0 Sm M01 M02 Pv1 Pv2 i j mdot1 mdot2 h_fairing_seperation ...
     ii jj Ne1 Ne2 Datapropultion m_fairing;

%% earth & gravity & atmospher
VCHAR1 = 0;
VCHAR2 = 0;
Vx = 0;
Vy = 0;
x = 0;
y = R*1000 + h0;
dt = 0.1;

r = sqrt(x^2 + y^2);
V = sqrt(Vx^2 + Vy^2);

Beta = asin(x/r);

if V == 0
    gama = pi/2;
else
    gama = asin(Vy/V) + Beta;
end

h = r - R*1000;

is = 1;
ax(is) = 0;
ay(is) = 0;
vx(is) = Vx;
vy(is) = Vy;
xx(is) = x;
yy(is) = y;

VCHARR(is) = 0;
alpha1(is) = 0;
gama1(is) = gama*180/pi;
Range(is) = Beta * 6378000;
Mach11(is) = 0;
hh(is) = h;
VV(is) = V;
t = 0;
tt(is) = t;

while t < tend
   is =is+1;
   
   if h<0 && sin(h) == 1
       break;
   end
   
   [pressure, ro, c] = Atmosphere_modeling(h);
   g = 3.986004e14/r^2;
   Mach = V/c;
   q = 0.5*ro*V^2;
   
   %% thrust & mass
   switch Nopt
       case 2
            if  t <= t1
                T = (Pv1*1000) - Datapropultion(i,9) .* Ne1(ii) .* pressure;
                M = M01 - mdot1.*t;
                if h > h_fairing_seperation
                    M= M-m_fairing;
                end
            else
                T = (Pv2*1000) - Datapropultion(j,9) .* Ne2(jj) .* pressure;
                M = M02 - mdot2.*(t-t1);
                if h > h_fairing_seperation
                    M= M-m_fairing;
                end
            end
                
   end
   
   %% pitch programming
   switch Nopt
       case 2
            if t<t0
                theta = pi/2;
                alpha = 0;
            elseif t <= t1
                theta = ((pi/2-theta_s)./(t1-t0).^2).*(t1-t).^2 + theta_s;
                alpha = theta - gama;
                VCHARdot1x = (Pv1*1000 / M*cos(theta-Beta));
                VCHARdot1y = (Pv1*1000 / M*sin(theta-Beta));
                VCHARdot1 = sqrt(VCHARdot1x^2 +VCHARdot1y^2);
                VCHAR1 = VCHAR1 + VCHARdot1*dt;
            elseif t<tend
                %theta = (0 * pi/180 - theta_s)/(tend-t) .* (t-t1) + theta_s;
                theta = theta_s + ((theta_s)*(t1-t)/(tend - t1));
                alpha = theta - gama;
                VCHARdot2x = (Pv2*1000 / M*cos(theta-Beta));
                VCHARdot2y = (Pv2*1000 / M*sin(theta-Beta));
                VCHARdot2 = sqrt(VCHARdot2x^2 +VCHARdot2y^2);
                VCHAR2 = VCHAR2 + VCHARdot2*dt;
            end
   end
   
   %% aerodynamic
   CD = 2.118*alpha^2 + (-0.1227)*alpha + 0.09732;
   CL = 1.695 * alpha + (-0.03037);
   
   D = q .* Sm .* (CD);
   L = q .* Sm .* CL;
   
   
   %% Equation
   Vxdot = 1/M*(-M*g*sin(Beta)-D*cos(gama-Beta)-L*sin(gama-Beta)+T*cos(theta-Beta));
   Vydot = 1/M*(-M*g*cos(Beta)-D*sin(gama-Beta)+L*cos(gama-Beta)+T*sin(theta-Beta));
   
   Vx = Vx+dt*Vxdot;
   Vy = Vy+dt*Vydot;
   
   x = x + Vx*dt;
   y = y + Vy*dt;
   
   r = sqrt(x^2 + y^2);
   h = r - R*1000;
   V = sqrt(Vx^2 + Vy^2);
   
   if y > 0
       Beta = asin(x/r);
   else
       Beta = pi - asin(x/r);
   end
   gama = asin(Vy/V) + Beta;
   
   if h>0
        ax(is) = Vxdot;
        ay(is) = Vydot;
        vx(is) = Vx;
        vy(is) = Vy;
        xx(is) = x;
        yy(is) = y;
        
        if t<=t1
            VCHARR1(is) = VCHAR1;
        else
           VCHARR2(is) = VCHAR2; 
        end
        alpha1(is) = alpha*180/pi;
        gama1(is) = gama*180/pi;
        theta1(is) = theta*180/pi;
        Beta1(is) = Beta*180/pi;
        Range(is) = Beta * 6378000;
        Mach11(is) = Mach;
        thrust(is) = T;
        cl(is) = CL;
        cd(is) = CD;
        hh(is) = h;
        DD(is) = D;
        LL(is) = L;
        VV(is) = V;
        tt(is) = t;
        t = t+dt;
end

end
VCHARR = VCHARR1(end) + VCHARR2(end);
end