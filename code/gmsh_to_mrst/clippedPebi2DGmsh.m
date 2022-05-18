function G = clippedPebi2DGmsh(resGridSize, pdims, faceConstraints)
% Construct a clipped Pebi grid, using Gmsh to generate nodes
% 
% SYNOPSIS:
%   G = clippedPebi2DGmsh(resGridSize, pdims, faceConstraints);
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

py.pebi_grid_2D.pebi_grid_2D(resGridSize, pyDims, faceConstraints);

if isfile('TEMP_Gmsh_MRST.m')
    pyG = gmshToMRST('TEMP_Gmsh_MRST.m');

    bnd = [
        0 0;
        pdims(1) 0;
        pdims(1) pdims(2);
        0 pdims(2);
    ];

    G = clippedPebi2D(pyG.nodes.coords, bnd);
    delete TEMP_Gmsh_MRST.m
else
    error("No file 'TEMP_Gmsh_MRST.m' generated by python call")
end

end