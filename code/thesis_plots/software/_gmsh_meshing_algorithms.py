import gmsh

gmsh.initialize()
gmsh.fltk.initialize()

# Create domain
corners = [
    gmsh.model.geo.add_point(0, 0, 0),
    gmsh.model.geo.add_point(1, 0, 0),
    gmsh.model.geo.add_point(1, 1, 0),
    gmsh.model.geo.add_point(0, 1, 0)
]
domain_edge = [
    gmsh.model.geo.add_line(corners[i], corners[i+1]) for i in range(len(corners) - 1)
] + [gmsh.model.geo.add_line(corners[-1], corners[0])]

circumference = gmsh.model.geo.add_curve_loop(domain_edge)

surface = gmsh.model.geo.add_plane_surface([circumference])

gmsh.model.geo.synchronize()

algorithms = {
    1: "MeshAdapt",
    5: "Delaunay",
    6: "Frontal-Delaunay",
    7: "BAMG",
    8: "Frontal-Delaunay for Quads"
}

for i, alg in algorithms.items():
    gmsh.option.setNumber("Mesh.Algorithm", i)
    gmsh.model.mesh.generate(2)

    gmsh.write(f"plots/gmsh_meshing_algorithms_{alg}.png")

# Create a line in the mesh
start = gmsh.model.geo.add_point(0.2, 0.2, 0)
end = gmsh.model.geo.add_point(0.8, 0.8, 0)
line = gmsh.model.geo.add_line(start, end)
gmsh.model.geo.synchronize()

gmsh.model.mesh.embed(1, [line], 2, surface)

for i, alg in algorithms.items():
    gmsh.option.setNumber("Mesh.Algorithm", i)
    gmsh.model.mesh.generate(2)

    gmsh.write(f"plots/gmsh_meshing_algorithms_embedded_{alg}.png")


gmsh.finalize()