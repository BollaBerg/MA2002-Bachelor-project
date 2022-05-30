import gmsh

# Always initialize gmsh
gmsh.initialize()

# Create the linear transfinite mesh
trans_lines = []        # For storing lines
trans_loops = []        # For storing curve loops
trans_surfaces = []     # For storing surfaces
for start_x in (0.2, 0.6):
    # Create transfinite mesh corners
    corner1 = gmsh.model.geo.add_point(start_x, 0.2, 0)
    corner2 = gmsh.model.geo.add_point(start_x + 0.2, 0.2, 0)
    corner3 = gmsh.model.geo.add_point(start_x + 0.2, 0.8, 0)
    corner4 = gmsh.model.geo.add_point(start_x, 0.8, 0)

    # Create transfinite mesh lines
    lines = [
        gmsh.model.geo.add_line(corner1, corner2),
        gmsh.model.geo.add_line(corner2, corner3),
        gmsh.model.geo.add_line(corner3, corner4),
        gmsh.model.geo.add_line(corner4, corner1)
    ]
    trans_lines.append(lines)
    
    # Create transfinite mesh curve loop, save it in trans_loops
    trans_loop = gmsh.model.geo.add_curve_loop(lines)
    trans_loops.append(trans_loop)

    # Create the transfinite mesh surface
    trans_surface = gmsh.model.geo.add_plane_surface([trans_loop])
    trans_surfaces.append(trans_surface)

# Make the first mesh transfinite
# We use 11 points along the short sides of the mesh,
# and 31 points along the long sides of the mesh
# This gives us a grid of 10 * 30 cells
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[0][0], 11)
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[0][1], 31)
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[0][2], 11)
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[0][3], 31)

# We can now make the surface transfinite
# If our surface had more than 4 corners, we would have to manually
# specify the corners to use for the transfinite interpolation
# This is automatic for 3 and 4 corners
gmsh.model.geo.mesh.set_transfinite_surface(trans_surfaces[0])

# We make the second mesh transfinite
# We keep the number of points, but make the points along the long
# sides follow a geometric progression with power = 1.5
# Note how we reverse the second line, to get a symmetric distribution
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[1][0], 11)
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[1][1], 31,
                                          coef=1.5)
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[1][2], 11)
gmsh.model.geo.mesh.set_transfinite_curve(trans_lines[1][3], 31,
                                          coef=-1.5)

gmsh.model.geo.mesh.set_transfinite_surface(trans_surfaces[1])

# Recombine triangles to get a rectangular grid
gmsh.model.geo.mesh.set_recombine(2, trans_surfaces[0])
gmsh.model.geo.mesh.set_recombine(2, trans_surfaces[1])


# Create a base surface
p1 = gmsh.model.geo.add_point(0, 0, 0)
p2 = gmsh.model.geo.add_point(1, 0, 0)
p3 = gmsh.model.geo.add_point(1, 1, 0)
p4 = gmsh.model.geo.add_point(0, 1, 0)

l1 = gmsh.model.geo.add_line(p1, p2)
l2 = gmsh.model.geo.add_line(p2, p3)
l3 = gmsh.model.geo.add_line(p3, p4)
l4 = gmsh.model.geo.add_line(p4, p1)

curve = gmsh.model.geo.add_curve_loop([l1, l2, l3, l4])

# We create the base surface everywhere except within the
# transfinite meshes we created
surface = gmsh.model.geo.add_plane_surface([curve] + trans_loops)

# Synchronize the CAD kernel to create Gmsh data structures
gmsh.model.geo.synchronize()

# Generate 2D mesh
gmsh.model.mesh.generate(2)

# Show the model by running the GUI
gmsh.fltk.run()

# Always finalize when done using the API
gmsh.finalize()