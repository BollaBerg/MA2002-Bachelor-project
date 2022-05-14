"""
Create a very simple GMSH plot, using user-supplied arguments, then save the
mesh to file.

Arguments:
    - cell dimensions: Tuple with len = 2. Basic cell size
        NOT CURRENTLY IMPLEMENTED!
    - size: Tuple with len = 2. Max size of the mesh (starts at (0, 0))
    - lines: Iterable of lines. Each element of lines should be an iterable of
        points on the line (i.e. start/end/corners). Equivalent to
        'faceConstraints' in pebiGrid2D in UPR.

Output:
    - Gmsh mesh saved to file `_pebi_grid_2D.m`
"""
from array import array
import sys
from typing import Union

import gmsh

def pebi_grid_2D(cell_dimensions: float, size: list, lines: Union[list, dict[dict]]):
    # Do some (massive) argument handling, for use in MATLAB
    if isinstance(lines, dict):
        if isinstance(list(lines.values())[0], array):
            # If data is sent from MATLAB, then lines is a dict
            # If there is only one line, then we accept it as a 1D dict, i.e.
            # lines is a dict in the shape {x: array, y: array}
            if "x" not in lines.keys() or "y" not in lines.keys():
                raise ValueError(
                    "If lines is a single-level dict, it must have keys x, y. "
                    + f"Current keys: {lines.keys()}"
                )
            lines = list(zip(lines.get("x"), lines.get("y")))

        elif isinstance(list(lines.values())[0], dict):
            # If data is sent from MATLAB, then lines is a dict of dicts
            # Each element in lines.values is a dict of {x: array, y: array}
            new_lines = []
            for line in lines.values():
                if "x" not in line.keys() or "y" not in line.keys():
                    raise ValueError(
                        "If lines is a 2D dict, then its values must have the "
                        + "keys x, y. "
                        + f"Current keys: {lines.keys()}, current lines: {lines}"
                    )
                new_lines.append(list(zip(line.get("x"), line.get("y"))))
            lines = new_lines

    gmsh.initialize()
    gmsh.model.add("pebiGrid2D")

    # Create corners
    corners = [
        gmsh.model.geo.add_point(0, 0, 0),
        gmsh.model.geo.add_point(0, size[1], 0),
        gmsh.model.geo.add_point(size[0], size[1], 0),
        gmsh.model.geo.add_point(size[0], 0, 0),
    ]

    # Create circumference lines
    circumference_lines = [
        gmsh.model.geo.add_line(corners[0], corners[1]),
        gmsh.model.geo.add_line(corners[1], corners[2]),
        gmsh.model.geo.add_line(corners[2], corners[3]),
        gmsh.model.geo.add_line(corners[3], corners[0]),
    ]

    # Create curve loop of circumference
    circumference = gmsh.model.geo.add_curve_loop(circumference_lines)
    
    # Define surface from circumference
    surface = gmsh.model.geo.add_plane_surface([circumference])

    fractures = []
    # Create fracture points
    for line in lines:
        if len(line) < 2:
            # No lines, only points
            raise NotImplementedError(
                f"Single-point fractures not implemented yet. Fracture: {line}"
            )
        
        for i in range(len(line) - 1):
            fracture_start = gmsh.model.geo.add_point(line[i][0], line[i][1], 0)
            fracture_end = gmsh.model.geo.add_point(line[i+1][0], line[i+1][1], 0)
            fractures.append(
                gmsh.model.geo.add_line(fracture_start, fracture_end)
            )

    # Synchronize to prepare for embedding fracture lines
    gmsh.model.geo.synchronize()

    # Embed all fractures
    gmsh.model.mesh.embed(1, fractures, 2, surface)

    # Generate 2D mesh
    gmsh.model.mesh.generate(2)

    # Save to disk
    gmsh.write("TEMPpebi_grid_2D.m")

    # Always finalize
    gmsh.finalize()


if __name__ == "__main__":
    try:
        cell_dimensions = sys.argv[1]
    except IndexError:
        cell_dimensions = 0.25
        print(f"No cell dimensions found. Default to {cell_dimensions}")

    try:
        size = sys.argv[2]
    except IndexError:
        size = [1, 1]
        print(f"No size found. Default to {size}")
    if len(size) < 2:
        raise ValueError(f"Size must have length >= 2. Current length: {len(size)}")

    
    try:
        lines = sys.argv[3]
    except IndexError:
        lines = []
        print("No lines found. Default to empty list.")
    
    pebi_grid_2D(cell_dimensions, size, lines)