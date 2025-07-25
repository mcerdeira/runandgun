extends CharacterBody2D
@export var direction = -1
var xp_drop = preload("res://scenes/xp_item.tscn")
var bullet_obj = preload("res://scenes/enemy_bullet.tscn")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump_ttl_total = 1.0
var jump_ttl = jump_ttl_total
var no_xp = false
var life = 3
var goback_ttl = 0.0
const blood = preload("res://scenes/blood.tscn")

func _ready() -> void:
	add_to_group("enemies")
	
func hit():
	if life > 0:
		bleed(5)
		life -= 1
		$sprite.material.set_shader_parameter("on", true)
		$hit_timer.start()
		if life <= 0:
			die()
		
func die(force_noxp = false):
	var dir = 1
	if force_noxp:
		no_xp = true
	
	if !no_xp and Global.pick_random([true, false]):
		for i in range(2):
			var xp = xp_drop.instantiate()
			xp.dir = dir
			xp.global_position = global_position
			dir *= -1
			get_parent().add_child(xp)
	bleed(15)
	queue_free()

func _physics_process(delta: float) -> void:
	Global.deletefromdistance(global_position, self)
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	jump_ttl -= 1 * delta 
	
	if is_on_floor() and jump_ttl <= 0:
		jump_ttl = jump_ttl_total
		velocity.y = JUMP_VELOCITY
		
	if is_on_wall():
		direction *= -1

	if goback_ttl > 0:
		goback_ttl -= 1 * delta
		
	$sprite.scale.x = direction * -1
	
	if goback_ttl > 0:
		velocity.x = (direction * -1) * SPEED
	else:
		velocity.x = direction * SPEED

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		velocity.y = JUMP_VELOCITY
		goback_ttl = 1.1
		body.hit()

func _on_hit_timer_timeout() -> void:
	$sprite.material.set_shader_parameter("on", false)

func bleed(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		get_parent().call_deferred("add_child", blood_instance)
