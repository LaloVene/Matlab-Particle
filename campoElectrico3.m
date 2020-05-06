function [ex, ey, ez, em] = campoElectrico3(q, x, y, z, px, py, pz, er)
% Función que calcula el campo eléctrico en los puntos indicados en el
% espacio producido por una carga eléctrica puntual.
% q - Carga de la partícula en coulombs
% x - Posición en x de la carga
% y - Posición en y de la carga
% z - Posición en z de la carga
% px - Coordenadas en x de los puntos a evaluar
% py - Coordenadas en y de los puntos a evaluar
% pz - Coordenadas en z de los puntos a evaluar
% er - Permitividad relativa del medio
% Salidas:
% ex = Componente en x del campo eléctrico
% ey = Componente en y del campo eléctrico
% ez = Componente en z del campo eléctrico
% em = Intensidad del campo eléctrico

% Calcula propiedades del medio 
e0 = 8.8541878176e-12;
ke = 1/(4*pi*er*e0);

% Calcula vectores r
rx = px - x;
ry = py - y;
rz = pz - z;
rm = sqrt(rx.^2 + ry.^2+ rz.^2);

% Calcula vectores unitarios
rxu = rx./rm;
ryu = ry./rm;
rzu = rz./rm;

% Calcula campo eléctrico
em = (ke*q)./(rm.^2);

ex = rxu.*em;
ey = ryu.*em;
ez = rzu.*em;

em = abs(em);

% Corrige todos aquellos vectores que tengan NaN debido a alguna operación
% inválida (0/0) (0*inf)
ex(isnan(ex)) = 0;
ey(isnan(ey)) = 0;
ez(isnan(ez)) = 0;

end

