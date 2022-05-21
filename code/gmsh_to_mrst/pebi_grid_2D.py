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


def _assert_column_in_dict(lines: dict, column: str):
    if column not in lines.keys():
        raise ValueError(
            f"Dictionary {dict} must contain column `{column}`!"
        )

def _assert_columns_have_same_length(lines: dict, col1: str, col2: str):
    if len(lines.get(col1)) != len(lines.get(col2)):
        raise ValueError(
            f"Column `{col1}` and `{col2}` must be the same length! "
            + f"len({col1}): {len(lines.get(col1))}, len({col2}): {len(lines.get(col2))}"
        )

def _check_array_dict_and_return_line_list(lines: dict):
    # Check that lines contains column x and y
    _assert_column_in_dict(lines, "x")
    _assert_column_in_dict(lines, "y")
    
    # Handle actual content
    if isinstance(lines.get("x"), float):
        # If the 'line' is a single point, then x and y are floats,
        # and must be handled explicitly
        return [(lines.get("x"), lines.get("y"))]
    else:
        # Assume 'line' is a list/tuple/Iterable of floats
        _assert_columns_have_same_length(lines, "x", "y")
        return list(zip(lines.get("x"), lines.get("y")))


def pebi_grid_2D(cell_dimensions: float, size: list,
                lines: Union['list[list]', 'dict[str, list]', 'dict[str, dict[str, list]]'],
                savename: str = "TEMP_Gmsh_MRST.m",
                _run_frontend: bool = False):
    # Do some (massive) argument handling, for use in MATLAB
    if isinstance(lines, dict):
        if len(lines) == 0:
            # Lines is an empty list -> No fractures to handle, simply create
            # a single mesh within size
            lines = []
        elif isinstance(list(lines.values())[0], array):
            # If data is sent from MATLAB, then lines is a dict
            # If there is only one line, then we accept it as a 1D dict, i.e.
            # one can write
            #   faceConstraints.x = [x1 ...];
            #   faceConstraints.y = [y1 ...];
            # Then lines is a dict in the shape {x: array, y: array}
            lines = _check_array_dict_and_return_line_list(lines)

        elif isinstance(list(lines.values())[0], dict):
            # If data is sent from MATLAB, then lines is a dict of dicts
            # If there are more than one line, then it must be a 2D dict, i.e.
            # one can write
            #   faceConstraints.line1.x = [x11 ...];
            #   faceConstraints.line1.y = [y11 ...];
            #   faceConstraints.line2.x = [x21 ...];
            #   faceConstraints.line2.y = [y21 ...];
            # Each element in lines.values is a dict of {x: array, y: array}
            new_lines = []
            for line in lines.values():
                new_lines.append(_check_array_dict_and_return_line_list(line))
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

    fracture_points = []
    fractures = []
    # Create fracture points
    for line in lines:
        # Handle single points their own way
        if len(line) == 1:
            fracture_points.append(
                gmsh.model.geo.add_point(line[0][0], line[0][1], 0)
            )
            continue
        
        # There exists a line with at least 1 segment
        # As line segment [i] starts with the end of line segment [i - 1],
        # we avoid doubling on points by moving fracture_start out of the loop
        fracture_start = gmsh.model.geo.add_point(line[0][0], line[0][1], 0)
        for i in range(1, len(line)):
            fracture_end = gmsh.model.geo.add_point(line[i][0], line[i][1], 0)
            fractures.append(
                gmsh.model.geo.add_line(fracture_start, fracture_end)
            )
            fracture_start = fracture_end

    # Synchronize to prepare for embedding fracture lines
    gmsh.model.geo.synchronize()

    # Embed all fractures
    gmsh.model.mesh.embed(1, fractures, 2, surface)
    gmsh.model.mesh.embed(0, fracture_points, 2, surface)

    # Refine mesh around fractures. We want a finer mesh around the fractures,
    # to ensure as close fit of faces as possible. In addition, this helps
    # handle intersecting fractures
    # This is gotten from
    # https://gitlab.onelab.info/gmsh/gmsh/-/blob/master/tutorials/python/t10.py

    # The Distance field returns the distance to (sampling) points on each
    # fracture
    sampling = 100
    gmsh.model.mesh.field.add("Distance", 1)
    gmsh.model.mesh.field.setNumbers(1, "PointsList", fracture_points)
    gmsh.model.mesh.field.setNumbers(1, "CurvesList", fractures)
    gmsh.model.mesh.field.setNumber(1, "Sampling", sampling)

    # The Treshold field uses the value from the Distance field to define a
    # change in element size depending on the computed distances
    min_factor = 1 / 3
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

    # Optionally save
    if savename is not None:
        gmsh.write(savename)
    
    # Optionally run frontend
    if _run_frontend:
        gmsh.fltk.run()

    # Always finalize
    gmsh.finalize()

if __name__ == "__main__":
    pebi_grid_2D(0.1, [1, 1], [
            [(0.25, 0.25), (0.4, 0.5), (0.75, 0.75)],
            [(0.8, 0.1), (0.9, 0.2)],
            [(0.2, 0.9), (0.9, 0.1)]
        ],
        savename=None,
        _run_frontend=True)