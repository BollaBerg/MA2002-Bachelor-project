"""
Attempt 2 at creating a copy of the given assignment solved in a_lineSites2D.m

The task is to create a square mesh, over [0, 1] x [0, 1], with a single line
from [0.25, 0.25] to [0.75, 0.75], and then export the underlying mesh and
import it into MRST/UPR.

This method takes inspiration from 
    https://bitbucket.org/mrst/mrst-model-io/src/master/gmsh/gmsh_scripts/fractures2D.py
and implements the mesh manually, in order to get a structured grid.
"""
import math

import gmsh


# CONSTANTS
fracture_points = [
    (0.25, 0.25), (0.75, 0.75)
]

base_grid_size = 0.1
tangential_fracture_grid_size = 0.1
normal_fracture_grid_size = 0.1


gmsh.initialize()
gmsh.model.add("linesites")

# Create a rectangle to use for our grid
grid = gmsh.model.occ.add_rectangle(0, 0, 0, dx=1, dy=1)

# Add fracture
fracture_start = gmsh.model.occ.add_point(
    fracture_points[0][0], fracture_points[0][1], 0
)
fracture_end = gmsh.model.occ.add_point(
    fracture_points[1][0], fracture_points[1][1], 0
)
fracture = gmsh.model.occ.add_line(fracture_start, fracture_end)


# Syncronize to greate the mesh
gmsh.model.occ.synchronize()

# Embed the fracture into the grid
gmsh.model.mesh.embed(1, [fracture], 2, grid)


## Create the field to use as background mesh
field = gmsh.model.mesh.field

# Create the actual background field
background_field = field.add("MathEval")

# Represent the fracture (length_of_curve / tangential_grid_size) points
distance_field = field.add("Distance")
field.setNumbers(distance_field, "CurvesList", [fracture])
num_points = round(
    math.dist(fracture_points[0], fracture_points[1]) / tangential_fracture_grid_size
)
field.setNumber(distance_field, "Sampling", num_points)

s = f"{base_grid_size} + ({normal_fracture_grid_size} - {base_grid_size}) * Exp(-F{distance_field}*F{distance_field} / {base_grid_size}^2)"
field.set_string(background_field, "F", s)
field.setAsBackgroundMesh(background_field)


# Enforce mesh size from field only
gmsh.option.setNumber("Mesh.MeshSizeExtendFromBoundary", 0)
gmsh.option.setNumber("Mesh.MeshSizeFromPoints", 0)
gmsh.option.setNumber("Mesh.MeshSizeFromCurvature", 0)

# Setup quad mesh, method 1
# This was, in this case, the best and most square option
gmsh.option.setNumber("Mesh.RecombinationAlgorithm", 0)
gmsh.option.setNumber("Mesh.RecombineAll", 1)

# Setup quad mesh, method 2
# This produced interesing almost-spherical shapes
# gmsh.option.setNumber("Mesh.SubdivisionAlgorithm", 1)

# Generate quad mesh
dim = 2
gmsh.model.mesh.generate(dim)


# Save the model
gmsh.write("c_gmsh_structured.m")

# gmsh.fltk.run()

gmsh.finalize()