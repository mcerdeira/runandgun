extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -550.0
var moving = false
var shoot_delay = 0.0
var camera_pos = 207.0
var bullet_obj = preload("res://scenes/bullet.tscn")
var dust_obj = preload("res://scenes/dust.tscn")
var scale_x = 1.0
var scale_y = 1.0
var jumping = false
var direction_shoot = "R"
var hit_ttl = 0
var hit_total = 7
var dont_move = true
const blood = preload("res://scenes/blood.tscn")

func _ready() -> void:
	add_to_group("players")
	Global.player_obj = self
	$sprite.animation = "idle"
	$sprite.play()
	
func hit(dmg = 5):
	if !Global.GAMEOVER: 
		if hit_ttl <= 0:
			bleed(5)
			hit_jump()
			Global.current_life -= dmg
			if Global.current_life > 0:
				Global.level_down(dmg)
				hit_ttl = hit_total
				Level2Goku()
				if Global.current_level == 0:
					$sprite.use_parent_material = false
					
				$timer_hit.start()
			else:
				die()
			
func die():
	if !Global.GAMEOVER:
		bleed(15)
		velocity.x = 0 
		dont_move = true
		Global.GAMEOVER = true
		$sprite.animation = "dead"
		$sprite/gun.visible = false
		Global.gameman_obj.create_message("GAME OVER", true)
	
func xp_up(val = 5):
	var lvl = Global.level_up(val)
	if lvl:
		$sprite.use_parent_material = true
		Level2Goku()
		
func Level2Goku():
	material.set_shader_parameter("maxLineWidth", Global.current_level * 3)
	
func shoot():
	if shoot_delay <= 0:
		Global.shaker_obj.shake(3.0, 1.0)
		shoot_delay = Global.shoot_delay_total
		var buff = 0.0
		var dir = 0.0

		var bullet = bullet_obj.instantiate()
		bullet.global_position = $sprite/gun/Marker2D.global_position
		bullet.rotation_degrees = $sprite/gun.rotation_degrees
		bullet.setmy_scale($sprite/gun.scale.x)
		if direction_shoot == "R":
			dir = 1.0
			bullet.direction = Vector2.RIGHT
		if direction_shoot == "L":
			dir = -1.0
			bullet.direction = Vector2.LEFT
		if direction_shoot == "U":
			dir = 0.0
			bullet.direction = Vector2.UP
		if direction_shoot == "RU":
			dir = 1.0
			bullet.direction = Vector2.from_angle(deg_to_rad(bullet.rotation_degrees))
		if direction_shoot == "LU":
			dir = -1.0
			bullet.direction =  Vector2.from_angle(deg_to_rad(bullet.rotation_degrees - 180))
		
		get_parent().add_child(bullet)
		
		if moving:
			buff = 50 * dir
	
func create_dust():
	var dust = dust_obj.instantiate()
	dust.global_position = Vector2(global_position.x, global_position.y + 10)
	get_parent().add_child(dust)
	
func hit_jump():
	jumping = true
	velocity.y = JUMP_VELOCITY / 3
	
func _physics_process(delta: float) -> void:
	if shoot_delay > 0:
		shoot_delay -= 1 * delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if jumping and is_on_floor():
		create_dust()
		jumping = false
		scale_x = 3.8
		scale_y = 0.1
		
	moving = false

	if !dont_move and Input.is_action_just_pressed("jump") and is_on_floor():
		create_dust()
		velocity.y = JUMP_VELOCITY
		scale_x = 0.1
		scale_y = 3.1
		jumping = true
		
	if scale_x > 1.0:
		scale_x = lerp(scale_x, 1.0, 0.3)
		
	if scale_x < 1.0:
		scale_x = lerp(scale_x, 1.0, 0.1)
		
	if scale_y > 1.0:
		scale_y = lerp(scale_y, 1.0, 0.1)
		
	if scale_y < 1.0:
		scale_y = lerp(scale_y, 1.0, 0.1)
		
	$sprite.scale.x = lerp($sprite.scale.x, scale_x, 0.1)
	$sprite.scale.y = lerp($sprite.scale.y, scale_y, 0.1)
		
	if !dont_move and Input.is_action_pressed("left"):
		direction_shoot = "L"
		velocity.x = -1 * SPEED
		moving = true
		$sprite.flip_h = true
		$sprite/gun.scale.x = -1
		camera_pos = -207.0
	elif !dont_move and Input.is_action_pressed("right"):
		direction_shoot = "R"
		velocity.x = 1 * SPEED
		moving = true
		$sprite.flip_h = false
		$sprite/gun.scale.x = 1
		camera_pos = 207.0
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		
	if !dont_move and Input.is_action_pressed("up") and Input.is_action_pressed("right"):
		direction_shoot = "RU"
		$sprite/gun.rotation_degrees = 313
	elif !dont_move and Input.is_action_pressed("up") and Input.is_action_pressed("left"):
		direction_shoot = "LU"
		$sprite/gun.rotation_degrees = 46
	elif !dont_move and Input.is_action_pressed("up"):
		direction_shoot = "U"
		if $sprite.flip_h:
			$sprite/gun.rotation_degrees = -270
		else:
			$sprite/gun.rotation_degrees = 270
	else:
		$sprite/gun.rotation_degrees = 0
		if $sprite/gun.scale.x == -1:
			direction_shoot = "L"
		else:
			direction_shoot = "R"
	
	if!dont_move and Input.is_action_pressed("shoot"):
		shoot()
		
	if !Global.GAMEOVER:
		if moving:
			$sprite.animation = "running"
		else:
			$sprite.animation = "idle"

		move_and_slide()
		
func bleed(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.blood_type = "blood_player"
		blood_instance.global_position = global_position
		get_parent().call_deferred("add_child", blood_instance)

func _on_timer_hit_timeout() -> void:
	hit_ttl -= 1
	#if hit_ttl % 2 == 0:
		#$sprite.material.set_shader_parameter("on", true)
		#$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0))
	#else:
		#$sprite.material.set_shader_parameter("on", false)
		#$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0))
		#
	#if hit_ttl == 0:
		#$sprite.material.set_shader_parameter("on", false)
		#$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0))
		#$timer_hit.stop()
