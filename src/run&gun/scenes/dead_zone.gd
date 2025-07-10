extends Area2D
@export var camera : Camera2D = null

func _process(delta: float) -> void:
	var ov = get_overlapping_bodies()
	if !ov:
		camera.followY()
