import gmsh

# Always initialize gmsh
gmsh.initialize()

# Gmsh can easily use different CAD kernels
# In this case, we use OpenCASCADE to create
# our base domain, starting at (0, 0, 0), with
# sides dx = dy = 1
surface = gmsh.model.occ.add_rectangle(0, 0, 0, 1, 1)

# Synchronize the CAD kernel to create Gmsh data structures
gmsh.model.occ.synchronize()

# Setup our base mesh size
base_size = 0.2

# Create our line
start = gmsh.model.occ.add_point(0.2, 0.2, 0)
end = gmsh.model.occ.add_point(0.8, 0.8, 0)
line = gmsh.model.occ.add_line(start, end)

# Create the point
point = gmsh.model.occ.add_point(0.3, 0.7, 0)

# Synchronize to ensure the new points are available for Gmsh
gmsh.model.occ.synchronize()

# Create a Distance field, calculating the distance from a line
line_distance = gmsh.model.mesh.field.add("Distance")
# Set the input of line_distance to be our line
gmsh.model.mesh.field.set_numbers(line_distance, "CurvesList", [line])
# Set the sample rate of the field to 100
gmsh.model.mesh.field.set_number(line_distance, "Sampling", 100)

# Now we create a Threshold field, using line_distance as our input
# We want to scale for all cells with a distance in [0.05, 0.2]
# We want the size of the cells to be in [base_size / 10, base_size]
line_thresh = gmsh.model.mesh.field.add("Threshold")
gmsh.model.mesh.field.setNumber(line_thresh, "InField", line_distance)
gmsh.model.mesh.field.setNumber(line_thresh, "SizeMin", base_size / 10)
gmsh.model.mesh.field.setNumber(line_thresh, "SizeMax", base_size)
gmsh.model.mesh.field.setNumber(line_thresh, "DistMin", 0.05)
gmsh.model.mesh.field.setNumber(line_thresh, "DistMax", 0.2)

# To use the point, we must set up another distance field
point_dist = gmsh.model.mesh.field.add("Distance")
gmsh.model.mesh.field.set_numbers(point_dist, "PointsList", [point])

# We can now create a MathEval field, using the square distance as our
# input. We shift F to so that the minimum mesh size is base_size / 10
point_field = gmsh.model.mesh.field.add("MathEval")
gmsh.model.mesh.field.set_string(point_field, "F",
    f"F{point_dist}^2 + {base_size / 10}"
)

# We can now create a Min field, to calculate the minimum of all the
# fields. We then set it as our mesh size field
min_field = gmsh.model.mesh.field.add("Min")
gmsh.model.mesh.field.setNumbers(min_field, "FieldsList",
    [line_thresh, point_field]
)
gmsh.model.mesh.field.setAsBackgroundMesh(min_field)

# Generate 2D mesh
gmsh.model.mesh.generate(2)

# Show the model by running the GUI
gmsh.fltk.run()

# Always finalize when done using the API
gmsh.finalize()