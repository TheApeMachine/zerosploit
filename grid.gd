extends ImmediateGeometry

var size_cell = 1
var size_grid = 20

func _ready():
	for cell in range(0, size_grid, size_cell):
		self.begin(ArrayMesh.PRIMITIVE_LINES, SpatialMaterial)
		self.add_vertex(Vector3(cell, 0, 0))
		self.add_vertex(Vector3(cell, 0, size_grid - 1))
		self.end()
		self.begin(ArrayMesh.PRIMITIVE_LINES, SpatialMaterial)
		self.add_vertex(Vector3(0, 0, cell))
		self.add_vertex(Vector3(size_grid - 1, 0, cell))
		self.end()
