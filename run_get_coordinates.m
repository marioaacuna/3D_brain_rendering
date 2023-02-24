%% preamble
%  This script will allow you to load a csv (or excel) table with the
%  Paxinos coordinates of lenses implantations (or any of that sort).
%  It will generate a new table with the CCF coordinates that then can be
%  used as inputs for any brain rendering pipeline. In this case we will
%  use the BrainMesh.m from https://github.com/Yaoyao-Hao/BrainMesh.
%% Read table
filename = fullfile(pwd, '_data',"Lens_positions_from_scans.xlsx");
T = readtable(filename);

%%
% Loop throuh animals

DV = T.DV*1000;
AP = T.AP_center*1000;
ML = T.ML_center*1000;
% Parameters for circle
radius = 500; % in um
resolution=10; % Check this value
radius = radius/resolution;
n = 36; %number of vertices
theta = linspace(0,2*pi,n+1);
theta(end) = []; %remove last point to have n vertices

% loop through the samples
animals = unique(T.animal_ID, 'stable');
n_animals= length(animals);
M = zeros(n_animals, 3);
for iid = 1:n_animals
    animal_ID = animals{iid};
    idx = find(ismember(T.animal_ID, animal_ID));
    if length(idx) > 1, keyboard; end

    ap = AP(idx);
    dv = DV(idx);
    ml = ML(idx);

    [x,y,z] = getCCFcoordinates(ap, dv, ml);
    M(iid,:) = [x,y,z];

    % Once you get the coordinates, create a circle structure with v and F
    xc = cos(theta)*radius + x;
    yc = sin(theta)*radius + z;
    zc = zeros(1,n) + y;
    v = [xc;zc;yc]';
    F = [1:n; [2:n 1]];
    clear ['xc','yc','zc']
    circletodraw.v = v;
    circletodraw.F = F;
    circle_filename = fullfile(pwd, '_data',[animal_ID,'_circle.mat']);
    save(circle_filename,"circletodraw")

end

% output matrix
clc
disp(M)
Matrix = struct();
Matrix= M;
matrix_filename = fullfile(pwd, "Matrix.mat");
save(matrix_filename,"Matrix")
disp('saved')

%% Create a structure with the circles for each sample
% with a radius of 100, at the position (1200, 25, 400)


% % loop though the samples
% 
% x = cos(theta)*radius + 1200;
% y = sin(theta)*radius + 25;
% z = zeros(1,n) + 400;
% v = [x;y;z]';
% F = [1:n; [2:n 1]];
% figure
% patch('Vertices',circletodraw.v,'Faces',circletodraw.F,'FaceColor','blue');
% view(3);
%% Open Brain mesh
BrainMesh()