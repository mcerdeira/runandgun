extends Node2D

func _on_sprite_animation_finished() -> void:
	queue_free()
