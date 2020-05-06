%% RETO PARTE 2
clc
clear

er = 1;                 % Permitividad relativa del medio
e0 = 8.8541878176e-12;  % Permitividad eléctrica en el vacío
ke = 1/(4*pi*er*e0);    % Constante eléctrica

%% Datos de entrada
N = 500;

% Valores de las cargas
Q = -1e-6;
q(1:N/2) = -Q/N;
q(N/2+1:N) = +Q/N;

% Particula
carga_particula = -1e-6;
mp = 2e-6;
px0 = 0.2;
py0 = 1.1;
pz0 = 0;
vx0 = -10;
vy0 = -50;
vz0 = -10;

% Posiciones en x de las cargas
distanciaP = 0.4;
qx(1:N/2) = 0;
qx(N/2+1:N) = abs(distanciaP);
posPlaca1 = 0;
posPlaca2 = distanciaP;

% Posiciones en y de las cargas
tam_placa1 = 1;
tam_placa2 = 0.3;

if tam_placa1 > tam_placa2
    difTam = tam_placa1-tam_placa2;
    qy1 = linspace(0, tam_placa1, N/2);
    qy2 = linspace(difTam/2, difTam/2 + tam_placa2, N/2);
    qy = [qy1,qy2];
else
    difTam = tam_placa2-tam_placa1;
    qy1 = linspace(difTam/2, difTam/2 +tam_placa1, N/2);
    qy2 = linspace(0, tam_placa2, N/2);
    qy = [qy1,qy2];
end

% Posiciones en z de las cargas
placaz0 = -0.1;
placaz1 = 0.1;
qz(1:N/2) = placaz0;
qz(N/2+1:N) = placaz1;

%% Calculo campo electrico

% Valores de x, y en donde se va a evaluar la carga
n = 35;
x = linspace( min(qx), max(qx), n);
y = linspace( min(qy), max(qy), n);
z = linspace( placaz0, placaz1, n);
[sx, sy, sz] = meshgrid(x, y, z);

ex = zeros(size(sx));
ey = zeros(size(sy));
ez = zeros(size(sz));

for k = 1 : length(qy)
    [exi, eyi, ezi] = campoElectrico3(q(k), qx(k), qy(k), qz(k), sx, sy, sz, er);
    ex = ex + exi;
    ey = ey + eyi;
    ez = ez + ezi;   
end

em = sqrt(ex.^2+ey.^2+ez.^2);

% Grafica campo eléctrico
hold on
quiver(sx, sy, ex./em, ey./em, 'color', 'green')
if tam_placa1>tam_placa2
    rectangle('Position', [posPlaca1-0.01, -0.02, 0.02, tam_placa1 + 0.04], 'FaceColor','r')  
    rectangle('Position', [posPlaca2, difTam/2-0.02, 0.02,  tam_placa2+0.04], 'FaceColor','b')
else
    rectangle('Position', [posPlaca1-0.01, difTam/2-0.02 0.02, tam_placa1+0.04], 'FaceColor','r')  
    rectangle('Position', [posPlaca2, -0.02, 0.02, tam_placa2+0.04], 'FaceColor','b')
end

xlabel('x')
ylabel('y')
title('Simulación')
axis([ min(qx)-0.1 max(qx)+0.1 min(qy)-0.1 max(qy)+0.1  ])

%% Simulación
clear sx; clear sy; clear sz;

% Tiempo de la simulación
tmax = 0.1;
dt = 0.0001;

% Instantes de tiempo de la simulación
t = 0:dt:tmax;
nt = length(t);

%% Calculos Simulación

% x
sx0 = px0;
ax0 = 0;
vx(1) = vx0 + ax0.*dt;
sx(1) = sx0 + vx0.*dt;

% y
sy0 = py0;
ay0 = 0;
vy(1) = vy0 + ay0.*dt;
sy(1) = sy0 + vy0.*dt;

% z
sz0 = placaz0;
az0 = 0;
vz(1) = vz0 + az0.*dt;
sz(1) = sz0 + vz0.*dt;

if py0< max( tam_placa1, tam_placa2) && py0>0 && px0>0 && px0<distanciaP
    fx(1)  = carga_particula.*-ex(1);
    fy(1)  = carga_particula.*ey(1);
    fz(1)  = carga_particula.*ez(1);
else
    fx(1) = 0;
    fy(1) = 0.1;
    fz(1) = 0;
end
ax(1) = fx(1)./mp;
ay(1) = fy(1)./mp;
az(1) = fz(1)./mp;

scatter(px0, py0, 100, 'b', 'filled')
curve = animatedline('Color','b','Marker', 'o','LineWidth',2);
set(gca,'XLim', [min(qx)-0.1 max(qx)+0.1], 'YLim', [min(qy)-0.1 max(qy)+0.1]);
legend("Campo Electrico",'Particula','Location','southwest');

i = 2;
for k = 2:nt
    
    if k> (i*nt/n)
        i = i+1;
    end

    % y
    vy(k) = vy(k-1) + ay(k-1).*dt;
    sy(k) = sy(k-1) + vy(k-1).*dt;
    
    
    % x
    vx(k) = vx(k-1) + ax(k-1).*dt;
    sx(k) = sx(k-1) + vx(k-1).*dt;

    % z
    vz(k) = vz(k-1) + az(k-1).*dt;
    sz(k) = sz(k-1) + vz(k-1).*dt;
    
    if sy(k)< max( tam_placa1, tam_placa2) && sy(k) >0 && sx(k)>0 && sx(k)<distanciaP
        fx(k)  = carga_particula.*-ex(i);
        fy(k)  = carga_particula.*ey(i);
        fz(k) = carga_particula.*ez(i);
        fy(k) = 0;
    else
        fx(k) = 0;
        fy(k) = 0;
        fz(k) = 0;
    end
    ax(k) = fx(k)./mp;
    ay(k) = fy(k)./mp;
    az(k) = fz(k)./mp;
    
    if sx(k) > distanciaP+0.015 || sx(k) < 0
        break
    end
    
    if mod(k,5)==0
        addpoints(curve, sx(k), sy(k) )
        drawnow
    end
    
end
hold off
