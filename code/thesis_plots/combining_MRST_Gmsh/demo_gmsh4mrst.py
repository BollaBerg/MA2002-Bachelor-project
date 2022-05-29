from gmsh4mrst import background_grid_2D, delaunay_grid_2D, pebi_base_2D

cell_size = 0.2
face_constraints = [
    [(0.1, 0.1), (0.4, 0.3), (0.2, 0.5), (0.1, 0.8), (0.4, 0.9)],
]
cell_constraints = [
    [(0.9, 0.9), (0.6, 0.7), (0.8, 0.5), (0.9, 0.2), (0.6, 0.1)],
]

background_grid_2D(
    cell_size,
    face_constraints = face_constraints,
    cell_constraints = cell_constraints,
    run_frontend=True
)

delaunay_grid_2D(
    cell_size,
    face_constraints = face_constraints,
    cell_constraints = cell_constraints,
    run_frontend=True
)

pebi_base_2D(
    cell_size,
    face_constraints = face_constraints,
    cell_constraints = cell_constraints,
    run_frontend=True
)