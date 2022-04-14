# A very simple Gmsh example / learning file
# Based entirely on the official Gmsh Python tutorial:
# https://gitlab.onelab.info/gmsh/gmsh/-/blob/gmsh_4_9_4/tutorials/python/t1.py
#
# This file starts with the very basics of Gmsh - learning basics for geometry,
# entities and physical groups
import gmsh

# We must always initialize gmsh before using any functions
gmsh.initialize()

# We start by adding a new model, named "model_1"
# Note that if we do not explicitly add a model, an unnamed model will be
# created when needed
gmsh.model.add("model_1")

# We use the built-in kernel in this example. All API functions for this kernel
# have the prefix: `gmsh.model.geo`
#
# The most basic elementary entity in Gmsh is a Point, added by
# `gmsh.model.geo.add_point`. Note the following arguments:
#   - The first three arguments are the coordinates of the point (x, y, z)
#   - The fourth argument is the target mest size close to the point (optional)
#   - We can also add a final argument, to manually tag the point (with a unique
#       positive integer. Note that the tag is returned by the function, so I
#       personally find this to be a better method (unless explicit tagging is
#       required for some reason)
mesh_size = 1e-2
point_1 = gmsh.model.geo.add_point(0, 0, 0, meshSize=mesh_size)
point_2 = gmsh.model.geo.add_point(0.2, 0, 0, meshSize=mesh_size)
point_3 = gmsh.model.geo.add_point(0.2, 0.3, 0, meshSize=mesh_size)
# Manually set the tag of point 4 - just to show how it can be done
gmsh.model.geo.add_point(0, 0.3, 0, meshSize=mesh_size, tag=4)


# The second type of elementary entities in Gmsh is a Curve, where straight 
# lines are the simplest. Adding a straight line is done through
# `gmsh.model.geo.add_line`. Note the following arguments:
#   - The first two arguments are point tags (start and end tag)
#   - We can, once again, add a manual tag (positive int), as a last optional
#       argument. I don't really like it in this case either, though
line_1 = gmsh.model.geo.add_line(point_1, point_2)
line_2 = gmsh.model.geo.add_line(point_3, point_2)
# Note that the point tag for line 4 (set explicitly above) is simply the 
# integer `4`
line_3 = gmsh.model.geo.add_line(point_3, 4)
# Do the same as for point 4 - just to illustrate a method
gmsh.model.geo.add_line(4, point_1, tag=4)


# The third elementary entity is the Surface. To create a simple rectangular
# surface from the curves (lines) added above, we must first create a curve
# loop. Curve loops are defined by an ordered list of connected curves, where
# the sign associated with each curve tells the direction of the line (note 
# that line2 is defined "backwards" in the code above).
# The API function to create a curve loop has the following arguments:
#   - A list of integers (curve tags)
#   - An optional curve loop tag (like for points and lines)
curve_loop = gmsh.model.geo.add_curve_loop([line_1, -line_2, line_3, 4])


# We can now define the surface as a list of curve loops. In this case we only
# have one loop (to define the outer perimeter), but we can create surfaces with
# holes, using more than one curve loop.
surface = gmsh.model.geo.add_plane_surface([curve_loop])


# Before we can mesh the surface (or use it or anything by API functions outside
# of the built-in CAD kernel functions), we need to syncronize the CAD entities
# with the Gmsh model, which creates relevant Gmsh data structures. For the
# built-in kernel, this is done through the following API method.
# Note that syncronizations can be done at any time, but because they involve
# non-trivial amounts of processing, we should usually try to minimize how much
# we syncronize.
gmsh.model.geo.synchronize()


# At this point, Gmsh knows everything it needs to display a rectangular surface
# and mesh it.
# If we want to group our geometrical entities into meaningful groups (based on
# things like mathematical (`domain`, `boundary`), functional (`body`, `wing`)
# or material (`wood`, `steel`) properties), we can do so by using Physical Groups.
# Physical Groups, like everything else, is identified by tags, which should be
# unique for each dimension (0D, 1D, 2D or 3D). They can also be given names.
#
# Note that if Physical Groups are defined, then only mesh elements belonging to
# a Physical Group will be exported. This can be overridden by forcing Gmsh to
# save all elements, by setting the `Mesh.SaveAll` option to 1.
# This can be done by the following API method:
#   `gmsh.option.set_number("Mesh.SaveAll", 1)`
#
# We define a physical curve that groups the left, bottom and right curves in a
# single group, then a physical surface with name "Square surface", containing
# our geometrical surface.
physical_curve = gmsh.model.add_physical_group(
    1,                      # Dimension of our Physical Group
    [line_1, line_2, 4]     # List of tags for our elements (in this case lines)
)
physical_surface = gmsh.model.add_physical_group(2, [surface])
gmsh.model.set_physical_name(
    2,                  # Dimension of our Physical Group
    physical_surface,   # Tag of our physical group
    "Square surface"    # Name of the group
)


# We can build models using other geometry kernels than the default built-in
# kernel. To use OpenCASCADE CAD kernel, we can use functions with the prefix
# `gmsh.model.occ`
# Different kernels have different features. With OpenCASCADE, we can define
# a surface directly, instead of defining 4 points -> 4 lines -> 1 curve loop:
occ_rectangle = gmsh.model.occ.add_rectangle(
    0.2,    # x-position of the lower left corner of the rectangle
    0.3,    # y-position of the lower left corner of the rectangle
    0,      # z-position of the lower left corner of the rectangle
    0.1,    # Changes in x direction (dx)
    0.1     # Changes in y direction (dy)
)

# We can now get the underlying curves and points by calling the following:
points = gmsh.model.get_boundary([(2, occ_rectangle), ])
occ_point_tags = [point[1] for point in points]

# We need to synchronize this kernel as well, like the built-in kernel above
gmsh.model.occ.synchronize()


# Aaand we need to add it to a physical group, so it is saved
occ_rectangle_group = gmsh.model.add_physical_group(2, [occ_rectangle])
occ_poing_group = gmsh.model.add_physical_group(1, occ_point_tags)
# NOTE: I haven't been able to get OCC to work yet. I hope I will get it up and
# running relatively soon(TM).


# We can now generate a 2D mesh
dimension = 2
gmsh.model.mesh.generate(dimension)


# We can save it to disk
# The default is to save meshes in the latest version of the Gmsh mesh file
# format (`.msh`). We can save meshes in other formats by specifying a file
# name with a different extension: `gmsh.write("gmsh1.unv")` will save the mesh
# in the UNV format.
# We can also save the mesh in older versions of the MSH format, by setting
# `gmsh.option.set_number("Mesh.MshFileVersion", x)` for a version number x
gmsh.write("01_basics.msh")


# ... or we can visualize the model in the graphical user interface
gmsh.fltk.run()


# We should call the finalize()-method when we are done using the Gmsh Python API
gmsh.finalize()

