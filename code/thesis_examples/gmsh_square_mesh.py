import gmsh

# Always initialize gmsh
gmsh.initialize()

# Create corner points
# Note that the mesh may look different if corners are
# defined clockwise instead of counter-clockwise
p1 = gmsh.model.geo.add_point(0, 0, 0)
p2 = gmsh.model.geo.add_point(1, 0, 0)
p3 = gmsh.model.geo.add_point(1, 1, 0)
p4 = gmsh.model.geo.add_point(0, 1, 0)

# Create line segments
l1 = gmsh.model.geo.add_line(p1, p2)
l2 = gmsh.model.geo.add_line(p2, p3)
l3 = gmsh.model.geo.add_line(p3, p4)
l4 = gmsh.model.geo.add_line(p4, p1)

# Create a curve loop of the edge lines
curve = gmsh.model.geo.add_curve_loop([l1, l2, l3, l4])

# Create a surface of the curve loop
surface = gmsh.model.geo.add_plane_surface([curve])

# Synchronize the CAD kernel to create Gmsh data structures
gmsh.model.geo.synchronize()

# Generate 2D mesh
gmsh.model.mesh.generate(2)

# Show the model by running the GUI
gmsh.fltk.run()

# Always finalize when done using the API
gmsh.finalize()