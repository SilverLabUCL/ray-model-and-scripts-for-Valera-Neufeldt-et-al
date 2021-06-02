%% Set up the z-planes of the optical path in space.

function Z = SetUp_opticalPath(OP)
    %% Z Planes
    Z.Ioz = 0 + OP.zError;                          % Z coordinate of input plane
    Z.Zaod = -[1 2 3 4]*OP.AODspacing + OP.zError;  % Z coordinates of AOD planes

    % Z coordinates of the two relay lens planes
    Z.z_relay = [Z.Zaod(4)-(OP.f_R1 + OP.zError)...
        Z.Zaod(4)-(OP.f_R1 + OP.zError)-(OP.f_R1 + OP.f_R2)];

    % Z coordinates of the objective lens plane
    Z.z_objective = Z.z_relay(2)-OP.f_R2-OP.focal_length;

    % Z coordinates of image planes
    Z.Imz = [Z.z_relay(2)-OP.f_R2 ...
        Z.z_objective ...
        Z.z_objective-0.5*OP.n*OP.focal_length...
        Z.z_objective-OP.n*OP.focal_length...
        Z.z_objective-1.5*OP.n*OP.focal_length...
        Z.z_objective-2*OP.n*OP.focal_length ];

    % Z_normalised_zero is the local z = 0 beneath the objective
    Z.Z_normalised_zero = Z.z_objective-OP.n*OP.focal_length +OP.zOffset;

    % All z-planes in the optical path
    Z.Zplanes = [Z.Ioz Z.Zaod Z.z_relay Z.Imz];
end