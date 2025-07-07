extends Area2D
var speed_original: float = 250.0
var speed: float = speed_original
var xp_drop = preload("res://scenes/xp_item.tscn")
var life = 1
var no_xp = false
var wait = 0.0
var return_to_pos = Vector2.ZERO
var return_ttl = 0.0

func _ready() -> void:
	add_to_group("enemies")
	
func hit():
	life -= 1
	$sprite.material.set_shader_parameter("on", true)
	$hit_timer.start()
	if life <= 0:
		die()
		
func die():
	if !no_xp:
		var xp = xp_drop.instantiate()
		xp.global_position = global_position
		get_parent().add_child(xp)
	queue_free()

func _physics_process(delta: float) -> void:
	Global.deletefromdistance(global_position, self)
	
	if global_position.x < Global.player_obj.global_position.x:
		$sprite.scale.x = 1
	else:
		$sprite.scale.x = -1
	
	$sprite.speed_scale = speed / speed_original
	
	if wait > 0:
		wait -= 1 * delta

	if return_ttl > 0:
		return_ttl -= 1 * delta
		var direction = (return_to_pos - global_position).normalized()
		global_position += direction * speed * delta
		if global_position.distance_to(return_to_pos) <= 5 or return_ttl <= 0:
			return_ttl = 0
			wait = 1.5
		
	if wait <= 0 and return_ttl <= 0:
		var direction = (Global.player_obj.global_position - global_position).normalized()
		global_position += direction * speed * delta
	
func _on_prechase_body_entered(body: Node2D) -> void:
	if speed == speed_original:
		if body and body.is_in_group("players"):
			return_to_pos = global_position
			wait = 1.5
			speed *= 1.5
	
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		$doaBarrelRoll.play("new_animation")
		speed = speed_original
		return_ttl = 2.3
		body.hit()

func _on_hit_timer_timeout() -> void:
	$sprite.material.set_shader_parameter("on", false)
