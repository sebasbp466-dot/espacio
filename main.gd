extends Node3D
var planeta: MeshInstance3D
func _ready():
	var cam = Camera3D.new()
	cam.position = Vector3(0, 0, 4)
	add_child(cam)
	var luz = DirectionalLight3D.new()
	luz.rotation_degrees = Vector3(-30, 40, 0)
	add_child(luz)
	planeta = MeshInstance3D.new()
	planeta.mesh = SphereMesh.new()
	add_child(planeta)
func _process(d):
	planeta.rotate_y(d * 0.5)
