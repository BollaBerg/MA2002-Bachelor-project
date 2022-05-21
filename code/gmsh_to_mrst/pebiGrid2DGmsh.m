function G = pebiGrid2DGmsh(resGridSize, pdims, faceConstraints)
% Construct a 2D grid, using Gmsh
% 
% SYNOPSIS:
%   G = pebiGrid2DGmsh(resGridSize, pdims, faceConstraints)
%
% PARAMETERS
%   resGridSize     - Size of the reservoir grid cells, in units of meters.
%
%   pdims           - Vector, length 2, [xmax, ymax], of physical size in
%                     units of meters of the computational domain
%
%   faceConstrants  - A struct of vectors. Each vector, size nf x 2, is the
%                     coordinates of a surface-trace. The surface is
%                     assumed to be linear between the coordinates. The
%                     function will place sites such that the surface is
%                     traced by faces of the grid.

pyDims = py.list(pdims);

py.pebi_grid_2D.pebi_grid_2D( ...
    cell_dimensions=resGridSize, ...
    size=pyDims, ...
    face_constraints=faceConstraints);
G = 0;

if isfile('TEMP_Gmsh_MRST.m')
    G = gmshToMRST('TEMP_Gmsh_MRST.m');
    delete TEMP_Gmsh_MRST.m
end

end