%% Timing offsets to correct for skew distortion arising from a finite xError and/or yError

function DC = SetUp_xyDistortionCorrection(DC,xCorr,yCorr,xCorr_sine,yCorr_sine)
% Tan Model
diff_x = xCorr;
diff_y = yCorr;

% Sine Model
diff_x_sin = xCorr_sine;
diff_y_sin = yCorr_sine;

% Different DiffX/Y and SumX/Y correction required for Sine and Tan models
DC.timing_offsets = 1e-6 * [diff_x, -diff_x, diff_y, -diff_y];
DC.timing_offsets_sin = 1e-6 * [diff_x_sin, -diff_x_sin, diff_y_sin, -diff_y_sin];
end
