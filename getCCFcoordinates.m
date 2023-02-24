function [X,Y,Z] = getCCFcoordinates(ap, dv, ml)
    %% Preamble
    % This function will get the Paxinos coordinates and will output the CCF coordinates.
    % Step 1: center the CCF on Bregma
    % The coordinates of Bregma depend on the resolution of the CCF
    % space you are using. For a 10 μm resolution Bregma is estimated at (x,y,z)
    % (540, 44, 570). For 25 μm this would be: (216, 18, 228).
    % Step 2: Rotate the CCF
    % The CCF is rotated 5 degrees in the sagittal plane compared to the
    % stereotactic atlas; the anterior part of the CCF is tilted in the ventral direction.
    % Step 3: squeeze the DV axis
    
    % We'll use the 10 μm resolution in the example below:
    %% Init
    % Set resolution
    resolution = 10;
    % Pass varialbes
    AP = ap;
    DV = abs(dv)+ 300; % it's always deeper than bregma around 300 microns
    ML = ml;
    % Resolve
    x = AP / resolution;
    y = DV / resolution;
    z = ML / resolution;
    if AP > 0
        X = 540 -x;
    else
        X = x + 540;
    end
    
    if ML >= 0 % right hemisphere
        Z = z + 570;
    else
        Z = z - 570;
    end
    Y = y + 44; % DV is always negative, therefore add.
    % Rotate (5 degrees = 0.0873)
    X = X * cos(0.0873) - Y * sin(0.0873);
    Y = Y * sin(0.0873) + Y * cos(0.0873);
    % Squeeze
    Y = Y * 0.9434;

    X = round(X);
    Y = round(Y);
    
end