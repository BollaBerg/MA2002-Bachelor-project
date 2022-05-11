"""
Attempt to create a copy of the given assignment solved in a_lineSites2D.m

The task is to create a square mesh, over [0, 1] x [0, 1], with a single line
from [0.25, 0.25] to [0.75, 0.75], and then export the underlying mesh and
import it into MRST/UPR.

NOTE: The output of this file raises the following error (but works):
    `Warning: No field 'faces.neighbors' found. Adding plausible values... proceed with caution!`
"""
import gmsh

# Initialize gmsh
gmsh.initialize()

# Create a model. We could skip this and let Gmsh create one, but it is nicer
# to be able to name the model ourself.
gmsh.model.add("task_model")

# Create corner points
corners = [
    gmsh.model.geo.add_point(0, 0, 0),
    gmsh.model.geo.add_point(0, 1, 0),
    gmsh.model.geo.add_point(1, 1, 0),
    gmsh.model.geo.add_point(1, 0, 0),    
]
# Create points for the fracture
# We want the mesh size around the fracture to be the same as in a_lineSites2D.m
mesh_size = 0.1
fracture_start = gmsh.model.geo.add_point(0.25, 0.25, 0, meshSize=mesh_size)
fracture_end = gmsh.model.geo.add_point(0.75, 0.75, 0, meshSize=mesh_size)

# Create circumference lines
circumference_lines = [
    gmsh.model.geo.add_line(corners[0], corners[1]),
    gmsh.model.geo.add_line(corners[1], corners[2]),
    gmsh.model.geo.add_line(corners[2], corners[3]),
    gmsh.model.geo.add_line(corners[3], corners[0]),
]
# Add the fracture line
fracture = gmsh.model.geo.add_line(fracture_start, fracture_end)


# Create a curve loop of the circumference
circumference = gmsh.model.geo.add_curve_loop(circumference_lines)


# We define the surface from a list of curve loops
# In our case, we want a surface from the circumference loop
surface = gmsh.model.geo.add_plane_surface([circumference])


# As always, we must syncronize the CAD entities with the Gmsh model
gmsh.model.geo.synchronize()


# To shape the mesh around the fracture, we "embed" it into the surface
gmsh.model.mesh.embed(1, [fracture], 2, surface)


# We can now generate a 2D mesh
dimension = 2
gmsh.model.mesh.generate(dimension)


# Save to disk
gmsh.write("b_gmsh_unstructured.m")


# ... or we can visualize the model in the graphical user interface
gmsh.fltk.run()


# We should call the finalize()-method when we are done using the Gmsh Python API
gmsh.finalize()

