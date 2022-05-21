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
    - Gmsh mesh saved to file TEMP_Gmsh_MRST.m`
"""
from array import array
from typing import Union

import gmsh

def pebi_grid_2D(cell_dimensions: float, size: list,
                lines: Union['list[list]', 'dict[str, list]', 'dict[str, dict[str, list]]'],
                _run_frontend: bool = False):
    # Do some (massive) argument handling, for use in MATLAB
    if isinstance(lines, dict):
        if len(lines) == 0:
            lines = []
        elif isinstance(list(lines.values())[0], array):
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

    # Refine mesh around fractures. We want a finer mesh around the fractures,
    # to ensure as close fit of faces as possible. In addition, this helps
    # handle intersecting fractures
    # This is gotten from
    # https://gitlab.onelab.info/gmsh/gmsh/-/blob/master/tutorials/python/t10.py

    # The Distance field returns the distance to (sampling) points on each
    # fracture
    sampling = 100
    gmsh.model.mesh.field.add("Distance", 1)
    gmsh.model.mesh.field.setNumbers(1, "CurvesList", fractures)
    gmsh.model.mesh.field.setNumber(1, "Sampling", sampling)

    # The Treshold field uses the value from the Distance field to define a
    # change in element size depending on the computed distances
    min_factor = 1 / 2
    min_distance = 0.05
    max_distance = 0.2
    gmsh.model.mesh.field.add("Threshold", 2)
    gmsh.model.mesh.field.setNumber(2, "InField", 1)
    gmsh.model.mesh.field.setNumber(2, "SizeMin", cell_dimensions * min_factor)
    gmsh.model.mesh.field.setNumber(2, "SizeMax", cell_dimensions)
    gmsh.model.mesh.field.setNumber(2, "DistMin", min_distance)
    gmsh.model.mesh.field.setNumber(2, "DistMax", max_distance)

    # We can use several fields here, see link above
    # We can then select the minimum of all fields

    # As we currently only have the treshold field, we use this as mesh
    gmsh.model.mesh.field.setAsBackgroundMesh(2)

    # As we define the entire element size in our background mesh, we disable
    # certain on-by-default mesh calculations
    gmsh.option.setNumber("Mesh.MeshSizeExtendFromBoundary", 0)
    gmsh.option.setNumber("Mesh.MeshSizeFromPoints", 0)
    gmsh.option.setNumber("Mesh.MeshSizeFromCurvature", 0)

    # We finally set the meshing algorithm to Delaunay.
    # According to the link above, Frontal-Delaunay (6) usually leads to the
    # highest quality meshes, but Delaunay (5) handles complex mesh sizes
    # better - especially size fields with large element size gradients
    gmsh.option.setNumber("Mesh.Algorithm", 5)

    # Generate 2D mesh
    gmsh.model.mesh.generate(2)

    if _run_frontend:
        gmsh.fltk.run()
    else:
        # Save to disk
        gmsh.write("TEMP_Gmsh_MRST.m")

    # Always finalize
    gmsh.finalize()

if __name__ == "__main__":
    pebi_grid_2D(0.1, [1, 1], [
            [[0.2, 0.5], [0.8, 0.5]],
            [(0.5, 0.2), (0.5, 0.8)],
        ],
        _run_frontend=True)