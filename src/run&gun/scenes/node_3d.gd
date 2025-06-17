extends Node3D
var taken = false

func _process(delta: float) -> void:
	if !taken:
		$MeshInstance3D.rotation_degrees.x += 100 * delta
		$MeshInstance3D.rotation_degrees.y += 100 * delta
		$MeshInstance3D.rotation_degrees.z += 100 * delta
