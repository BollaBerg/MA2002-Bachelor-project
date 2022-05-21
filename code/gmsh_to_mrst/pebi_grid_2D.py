"""
Create a very simple GMSH plot, using user-supplied arguments, then save the
mesh to file.

Arguments:
    - cell dimensions: Tuple with len = 2. Basic cell size
        NOT CURRENTLY IMPLEMENTED!
    - size: Tuple with len = 2. Max size of the mesh (starts at (0, 0))
    - face_constraints: Iterable of face_constraints. Each element of face_constraints should be an iterable of
        points on the line (i.e. start/end/corners). Equivalent to
        'faceConstraints' in pebiGrid2D in UPR.

Output:
    - Gmsh mesh saved to file TEMP_Gmsh_MRST.m`
"""
from array import array
from itertools import combinations
from typing import Any, Union, Iterable

import gmsh


def pebi_grid_2D(
        cell_dimensions: float,
        *,
        size: list = None,
        face_constraints: Union[
                    'list[list[Iterable]]',
                    'dict[str, float]',
                    'dict[str, Iterable]',
                    'dict[str, dict[str, float]]',
                    'dict[Any, dict[str, Iterable]]'] = None,
        face_constraint_factor: float = 1/3,
        min_threshold_distance: float = 0.05,
        max_threshold_distance: float = 0.2,
        face_intersection_factor: float = None,
        min_intersection_distance: float = None,
        max_intersection_distance: float = None,
        fracture_mesh_sampling: int = 100,
        mesh_algorithm: str = "Delaunay",
        savename: str = "TEMP_Gmsh_MRST.m",
        run_frontend: bool = False
    ):
    """Create a 2D mesh, with user-supplied face constraints.

    This project was done as part of my Bachelor thesis during spring 2022, in
    order to help provide a secondary backend to the SINTEF-developed MATLAB
    module MRST, and its submodule UPR. For more information about MRST, see
    https://www.sintef.no/projectweb/mrst/. For more information about UPR, see
    https://www.sintef.no/projectweb/mrst/modules/upr/

    Args:
        cell_dimensions (float): Base dimensions of each cell.
        size (list, optional): Size of the domain, in the shape [xmax, ymax].
            The domain always starts at [0, 0]. If None, size will be set to
            [1, 1]. Defaults to None.
        face_constraints (list[Iterable] | dict[str, float] | dict[str, Iterable]
                | dict[str, dict[str, float]] | dict[str, dict[str, Iterable]],
                optional):
            Constraints for the cell faces. Each constraint is the coordinate
            of a surface-trace. The surface is assumed to be linear between 
            the coordinates. The resulting mesh will place sites such that 
            the surfaces are traced by faces of the grid.
            Legal forms:
                list[list[Iterable]]: Primarily used when calling the function
                    from Python. Each element of face constraint is a list of
                    point(s) along the constraint. Note that each element must
                    be a list of points, even if there is only one point!
                    Examples:
                        >>> face_constraints = [
                                [(0.1, 0.1), (0.9, 0.9)],
                                [(0.2, 0.8), (0.5, 0.5), (0.8, 0.2)]
                            ]
                        >>> face_constraints = [
                                [(0.5, 0.5)],
                                [(0.1, 0.1), (0.9, 0.9)]
                            ]
                dict[str, float] | dict[str, list]: Used for only one
                    constraint line, primarily when the function is called
                    from MATLAB. face_constraints must contain the keys "x" and
                    "y", with the corresponding float or list being the x- and
                    y-coordinates of point(s) along the constraint.
                    Examples:
                        >>> face_constraints = {"x": [0.1, 0.9], "y": [0.1, 0.9]}
                        >>> face_constraints = {"x": 0.5, "y": 0.5}
                dict[Any, dict[str, float]] | dict[Any, dict[str, Iterable]]:
                    Used for more than one constraint line, primarily when the
                    function is called from MATLAB. Each element in
                    face_constraints.values() must contain keys "x" and "y",
                    with the corresponding float or list being the x- and y-
                    coordinates of point(s) along the constraint. It does not
                    matter what is used as keys for the top-level dictionary.
                    Examples:
                        >>> face_constraints = {
                            "line": {"x": [0.1, 0.9], "y": [0.1, 0.9]},
                            "point": {"x": 0.5, "y": 0.5},
                            "keys dont matter": {"x": 0.1, "y": 0.9}.
                            2022: {"x": 0.9, "y": 0.1}
                        }
            NOTE: Any constraints must be wholly within the supplied domain,
            i.e. completely within the rectangle between [0, 0] and `size`!.
            If None, face_constraints will be an empty list. Defaults to None.
        face_constraint_factor (float, optional): The size of the cells close
            to the face constraints, as compared to supplied cell_dimensions.
            Cells within min_threshold_distance will have size
            face_constraint_factor * cell_dimensions. Equivalent to FCFactor in
            MRST/UPR/pebiGrid2D. Defaults to 1/3.
        min_threshold_distance (float, optional): Distance from face constraints
            where cell dimensions will start increasing. Defaults to 0.05.
        max_threshold_distance (float, optional): Distance from face constraints
            where cell dimensions will be back to their default (max) value,
            i.e. the supplied argument cell_dimensions. Defaults to 0.2.
        face_intersection_factor (float, optional): The size of the cells close
            to intersections between face constraints, as compared to supplied
            cell_dimensions. Cells within min_threshold_distance from an 
            intersection will have size face_intersection_factor * cell_dimensions.
            If None, no extra cell shaping will occur around intersections.
            The factor is also used in "breaks" of lines, i.e. if there is a
            sharp "turn" in a line segment. Defaults to None.
        min_intersection_distance (float, optional): Distance from intersections
            where cell dimensions will start increasing. If None, will use
            min_threshold_distance. Defaults to None.
        max_intersection_distance (float, optional): Distance from intersections
            where cell dimensions will be back to their default (max) value,
            i.e. the supplied argument cell_dimensions. If None, will use
            min_threshold_distance. Defaults to None.
        fracture_mesh_sampling (int, optional): The number of points along the
            face constraints should be sampled to calculate the threshold
            distances. Defaults to 100.
        mesh_algorithm (str, optional): What meshing algorithm should be used.
            Can either be the Gmsh-given ID of the algorithm, a string:
                "MeshAdapt" = 1
                "Automatic" = 2
                "Delaunay" = 5
                "Frontal" = 6
                "BAMG" = 7
                "DelQuad" = 8
            Defaults to "Delaunay".
        savename (str, optional): Name of the saved file. If None, no file will
            be saved. The MATLAB functions assume that the file will be saved
            as "TEMP_Gmsh_MRST.m". Defaults to "TEMP_Gmsh_MRST.m".
        run_frontend (bool, optional): Set to True in order to run the Gmsh
            frontend and show the created mesh. Defaults to False.
    """
    if face_constraints is None:
        face_constraints = []
    if size is None:
        size = [1, 1]
    if min_intersection_distance is None:
        min_intersection_distance = min_threshold_distance
    if max_intersection_distance is None:
        max_intersection_distance = max_threshold_distance

    # Handle mesh algorithm
    # According to 
    # https://gitlab.onelab.info/gmsh/gmsh/-/blob/master/tutorials/python/t10.py
    # Frontal-Delaunay (6) usually leads to the highest quality meshes, but
    # Delaunay (5) handles complex mesh sizes better - especially size fields
    # with large element size gradients. We therefore default to Delaunay.
    # For quad-shaped grids, "Frontal-Delaunay for Quads" (8) may be beneficial.
    mesh_algorithm_dict = {
        "meshadapt": 1,
        "automatic": 2,
        "delaunay": 5,
        "frontal": 6,
        "bamg": 7,
        "delquad": 8
    }
    if isinstance(mesh_algorithm, int):
        if mesh_algorithm not in mesh_algorithm_dict.values():
            raise ValueError(
                "mesh_algorithm must be a legal value. Current value: "
                + f"{mesh_algorithm}. Legal values: {mesh_algorithm_dict}"
            )
    else:
        mesh_algorithm = mesh_algorithm_dict.get(mesh_algorithm.lower(), 5)
    
    # Do some (massive) argument handling, for use in MATLAB
    if isinstance(face_constraints, dict):
        if len(face_constraints) == 0:
            # face_constraints is an empty list -> No fractures to handle,
            # simply create a single mesh within size
            face_constraints = []
        elif isinstance(list(face_constraints.values())[0], array):
            # If data is sent from MATLAB, then face_constraints is a dict
            # If there is only one line, then we accept it as a 1D dict, i.e.
            # one can write
            #   faceConstraints.x = [x1 ...];
            #   faceConstraints.y = [y1 ...];
            # Then face_constraints is a dict in the shape {x: array, y: array}
            face_constraints = _check_array_dict_and_return_line_list(face_constraints)

        elif isinstance(list(face_constraints.values())[0], dict):
            # If data is sent from MATLAB, then face_constraints is a dict of dicts
            # If there are more than one line, then it must be a 2D dict, i.e.
            # one can write
            #   faceConstraints.line1.x = [x11 ...];
            #   faceConstraints.line1.y = [y11 ...];
            #   faceConstraints.line2.x = [x21 ...];
            #   faceConstraints.line2.y = [y21 ...];
            # Each element in face_constraints.values is a dict of {x: array, y: array}
            new_face_constraints = []
            for constraint in face_constraints.values():
                new_face_constraints.append(
                    _check_array_dict_and_return_line_list(constraint)
                )
            face_constraints = new_face_constraints
    
    gmsh.initialize()
    gmsh.model.add("pebiGrid2D")

    # Create corners
    corners = [
        gmsh.model.geo.add_point(0, 0, 0),
        gmsh.model.geo.add_point(0, size[1], 0),
        gmsh.model.geo.add_point(size[0], size[1], 0),
        gmsh.model.geo.add_point(size[0], 0, 0),
    ]

    # Create circumference face_constraints
    circumference_face_constraints = [
        gmsh.model.geo.add_line(corners[0], corners[1]),
        gmsh.model.geo.add_line(corners[1], corners[2]),
        gmsh.model.geo.add_line(corners[2], corners[3]),
        gmsh.model.geo.add_line(corners[3], corners[0]),
    ]

    # Create curve loop of circumference
    circumference = gmsh.model.geo.add_curve_loop(circumference_face_constraints)
    
    # Define surface from circumference
    surface = gmsh.model.geo.add_plane_surface([circumference])

    fracture_points = []
    fractures = []
    if face_intersection_factor is not None:
        line_segments = []
    # Create fracture points
    for line in face_constraints:
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

            if face_intersection_factor is not None:
                line_segments.append([(line[i-1][0], line[i-1][1]), (line[i][0], line[i][1])])
    
    # Calculate intersections
    intersection_points = []
    if face_intersection_factor is not None:
        for line_1, line_2 in combinations(line_segments, 2):
            intersection = _find_intersection(
                line_1[0], line_1[1], line_2[0], line_2[1]
            )
            if intersection is not None:
                intersection_points.append(
                    gmsh.model.geo.add_point(intersection[0], intersection[1], 0)
                )


    # Synchronize to prepare for embedding fracture face_constraints
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
    gmsh.model.mesh.field.add("Distance", 1)
    gmsh.model.mesh.field.setNumbers(1, "PointsList", fracture_points)
    gmsh.model.mesh.field.setNumbers(1, "CurvesList", fractures)
    gmsh.model.mesh.field.setNumber(1, "Sampling", fracture_mesh_sampling)

    # The Treshold field uses the value from the Distance field to define a
    # change in element size depending on the computed distances
    gmsh.model.mesh.field.add("Threshold", 2)
    gmsh.model.mesh.field.setNumber(2, "InField", 1)
    gmsh.model.mesh.field.setNumber(2, "SizeMin",
        face_constraint_factor * cell_dimensions
    )
    gmsh.model.mesh.field.setNumber(2, "SizeMax", cell_dimensions)
    gmsh.model.mesh.field.setNumber(2, "DistMin", min_threshold_distance)
    gmsh.model.mesh.field.setNumber(2, "DistMax", max_threshold_distance)

    # Add field for intersection points
    gmsh.model.mesh.field.add("Distance", 3)
    gmsh.model.mesh.field.setNumbers(3, "PointsList", intersection_points)
    gmsh.model.mesh.field.add("Threshold", 4)
    gmsh.model.mesh.field.setNumber(4, "InField", 3)
    gmsh.model.mesh.field.setNumber(4, "SizeMax", cell_dimensions)
    gmsh.model.mesh.field.setNumber(4, "DistMin", min_intersection_distance)
    gmsh.model.mesh.field.setNumber(4, "DistMax", max_intersection_distance)
    if face_intersection_factor is not None:
        gmsh.model.mesh.field.setNumber(4, "SizeMin",
            face_intersection_factor * cell_dimensions
        )

    # We use the minimum of all fields as our background mesh
    gmsh.model.mesh.field.add("Min", 5)
    gmsh.model.mesh.field.setNumbers(5, "FieldsList", [2, 4])
    gmsh.model.mesh.field.setAsBackgroundMesh(5)

    # As we define the entire element size in our background mesh, we disable
    # certain on-by-default mesh calculations
    gmsh.option.setNumber("Mesh.MeshSizeExtendFromBoundary", 0)
    gmsh.option.setNumber("Mesh.MeshSizeFromPoints", 0)
    gmsh.option.setNumber("Mesh.MeshSizeFromCurvature", 0)

    # We finally set the meshing algorithm.
    gmsh.option.setNumber("Mesh.Algorithm", mesh_algorithm)

    # Generate 2D mesh
    gmsh.model.mesh.generate(2)

    # Optionally save
    if savename is not None:
        gmsh.write(savename)
    
    # Optionally run frontend
    if run_frontend:
        gmsh.fltk.run()

    # Always finalize
    gmsh.finalize()




############################## HELPER FUNCTIONS ##############################
def _assert_column_in_dict(face_constraints: dict, column: str):
    if column not in face_constraints.keys():
        raise ValueError(
            f"Dictionary {dict} must contain column `{column}`!"
        )

def _assert_columns_have_same_length(face_constraints: dict, col1: str, col2: str):
    if len(face_constraints.get(col1)) != len(face_constraints.get(col2)):
        raise ValueError(
            f"Column `{col1}` and `{col2}` must be the same length! "
            + f"len({col1}): {len(face_constraints.get(col1))}, len({col2}): {len(face_constraints.get(col2))}"
        )

def _check_array_dict_and_return_line_list(face_constraints: dict):
    # Check that face_constraints contains column x and y
    _assert_column_in_dict(face_constraints, "x")
    _assert_column_in_dict(face_constraints, "y")
    
    # Handle actual content
    if isinstance(face_constraints.get("x"), float):
        # If the 'line' is a single point, then x and y are floats,
        # and must be handled explicitly
        return [(face_constraints.get("x"), face_constraints.get("y"))]
    else:
        # Assume 'line' is a list/tuple/Iterable of floats
        _assert_columns_have_same_length(face_constraints, "x", "y")
        return list(zip(face_constraints.get("x"), face_constraints.get("y")))

def _find_intersection(line_1_start, line_1_end, line_2_start, line_2_end):
    """Find the intersection of two line segments.

    Method inspired by
    https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect#565282
    with credit, quote:
        "Credit: this method is the 2-dimensional specialization of the 3D line
        intersection algorithm from the article 'Intersection of two lines in
        three-space' by Ronald Goldman, published in Graphics Gems, page 304

    Args:
        line_1_start (tuple): Start point of line 1
        line_1_end (tuple): End point of line 1
        line_2_start (tuple): Start point of line 2
        line_2_end (tuple): End point of line 2
    """
    if line_1_start[0] > line_1_end[0]:
        line_1_start, line_1_end = line_1_end, line_1_start
    if line_2_start[0] > line_2_end[0]:
        line_2_start, line_2_end = line_2_end, line_2_start
    
    def cross_product(v, w):
        return v[0]*w[1] - v[1]*w[0]
    
    delta_1 = [line_1_end[0]-line_1_start[0], line_1_end[1]-line_1_start[1]] #r
    delta_2 = [line_2_end[0]-line_2_start[0], line_2_end[1]-line_2_start[1]] #s

    if cross_product(delta_1, delta_2) == 0:
        # Either parallel or collinear -> No intersections we need to consider
        return None
    
    line_difference = [                         # (q - p)
        line_2_start[0] - line_1_start[0],
        line_2_start[1] - line_1_start[1]
    ]
    t = cross_product(line_difference, delta_2) / cross_product(delta_1, delta_2)
    u = cross_product(line_difference, delta_1) / cross_product(delta_1, delta_2)
    if 0 <= t <= 1 and 0 <= u <= 1:
        return [line_1_start[0] + t * delta_1[0], line_1_start[1] + t * delta_1[1]]
    else:
        return None

############################## END OF HELPERS ##############################



if __name__ == "__main__":
    pebi_grid_2D(
        0.2, 
        face_constraints=[
            [(0.25, 0.25), (0.4, 0.5), (0.75, 0.75)],
            [(0.8, 0.1), (0.9, 0.2)],
            [(0.2, 0.9), (0.9, 0.1)]
        ],
        size=[1, 1],
        face_constraint_factor = 1/3,
        face_intersection_factor = 1/9,
        savename=None,
        run_frontend=True)