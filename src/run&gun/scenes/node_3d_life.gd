extends Node3D
var taken = false

func _process(delta: float) -> void:
	if !taken:
		$heart_teamRed_gltf.rotation_degrees.y += 100 * delta
