extends CharacterBody2D
var xp_drop = preload("res://scenes/xp_item.tscn")
var bullet_obj = preload("res://scenes/enemy_bullet.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump_ttl_total = 3.0
var jump_ttl = jump_ttl_total
var no_xp = false
var life = 3

func _ready() -> void:
	add_to_group("enemies")
	
func hit():
	if life > 0:
		life -= 1
		$sprite.material.set_shader_parameter("on", true)
		$hit_timer.start()
		if life <= 0:
			die()
		
func die():
	var dir = 1
	if !no_xp:
		for i in range(2):
			var xp = xp_drop.instantiate()
			xp.dir = dir
			xp.global_position = global_position
			dir *= -1
			get_parent().add_child(xp)
	queue_free()

func _physics_process(delta: float) -> void:
	Global.deletefromdistance(global_position, self)
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	jump_ttl -= 1 * delta 
	
	if is_on_floor() and jump_ttl <= 0:
		jump_ttl = jump_ttl_total
		velocity.y = JUMP_VELOCITY

	var direction = -1
	velocity.x = direction * SPEED

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		body.hit()

func _on_hit_timer_timeout() -> void:
	$sprite.material.set_shader_parameter("on", false)
