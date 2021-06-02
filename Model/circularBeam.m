function [xCirc,yCirc,circlePixels] = circularBeam(xSquare,ySquare)

%% Create a circular beam by applying a circular mask:
imageSizeX = length(xSquare);
imageSizeY = length(ySquare);
[columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);

centerX = round(imageSizeX/2);
centerY = round(imageSizeX/2);
radius = (imageSizeX-1)/2;
circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
circlePixels = double(circlePixels);
pixels = circlePixels == 0;
circlePixels(pixels) = 0;

%% Coordinates of the circular beam
xCirc = circlePixels.*xSquare;
yCirc = circlePixels.*ySquare;

end