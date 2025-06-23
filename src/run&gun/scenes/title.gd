extends Node2D
var ttl = 2.1
var start = false
var finish1 = false

func _ready() -> void:
	$AnimationPlayer.play("new_animation")
	
func _physics_process(delta: float) -> void:
	if !start:
		if Input.is_action_just_pressed("ui_accept"):
			start = true
			$AnimationPlayer.speed_scale = 5
	else:
		if !finish1:
			ttl -= 1 * delta
			if ttl <= 0:
				finish1 = true
				$AnimationPlayer.stop()
				$Label.visible = false
				$StartAnimation.play("new_animation")
				
func _on_start_animation_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/testlevel.tscn")
