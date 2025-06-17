extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("new_animation")

func start_dust():
	$sprite2.visible = true
	$sprite3.visible = true
	
func end_dust():
	$sprite2.visible = false
	$sprite3.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
