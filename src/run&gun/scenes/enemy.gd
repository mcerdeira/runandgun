extends Area2D
var speed_original: float = 250.0
var speed: float = speed_original
var xp_drop = preload("res://scenes/xp_item.tscn")
var life = 1
var no_xp = false
var wait = 0.0

func _ready() -> void:
	add_to_group("enemies")
	
func hit():
	life -= 1
	if life <= 0:
		die()
		
func die():
	if !no_xp:
		for i in range(2):
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
		
	if wait <= 0:
		var direction = (Global.player_obj.global_position - global_position).normalized()
		global_position += direction * speed * delta
	
func _on_prechase_body_entered(body: Node2D) -> void:
	if speed == speed_original:
		if body and body.is_in_group("players"):
			wait = 1.5
			speed *= 1.5
		
func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		speed = speed_original
		wait = 2.3
		body.hit()
