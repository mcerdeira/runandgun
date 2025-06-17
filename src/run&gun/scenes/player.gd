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
var hit_total = 25

func _ready() -> void:
	add_to_group("players")
	$sprite.animation = "idle"
	$sprite.play()
	Global.shaker_obj.camera = $Camera2D
	
func hit(dmg = 1):
	if hit_ttl <= 0:
		Global.current_life -= dmg
		if Global.current_life > 0:
			Global.level_down(dmg)
			hit_ttl = hit_total
			$timer_hit.start()
		else:
			die()
			
func die():
	Global.GAMEOVER = true
	
func xp_up():
	Global.level_up()
	$sprite.material.set_shader_parameter("on", true)
	$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 0.196))
	await get_tree().create_timer(0.3).timeout
	$sprite.material.set_shader_parameter("on", false)
	$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0))
	
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

	if Input.is_action_just_pressed("jump") and is_on_floor():
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
		
	if Input.is_action_pressed("left"):
		direction_shoot = "L"
		velocity.x = -1 * SPEED
		moving = true
		$sprite.flip_h = true
		$sprite/gun.scale.x = -1
		camera_pos = -207.0
	elif Input.is_action_pressed("right"):
		direction_shoot = "R"
		velocity.x = 1 * SPEED
		moving = true
		$sprite.flip_h = false
		$sprite/gun.scale.x = 1
		camera_pos = 207.0
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		
	if Input.is_action_pressed("up") and Input.is_action_pressed("right"):
		direction_shoot = "RU"
		$sprite/gun.rotation_degrees = 313
	elif Input.is_action_pressed("up") and Input.is_action_pressed("left"):
		direction_shoot = "LU"
		$sprite/gun.rotation_degrees = 46
	elif Input.is_action_pressed("up"):
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
		
	$Camera2D.position.x = lerp($Camera2D.position.x, camera_pos, 0.03)
	
	if Input.is_action_pressed("shoot"):
		shoot()
		
	if moving:
		$sprite.animation = "running"
	else:
		$sprite.animation = "idle"

	move_and_slide()

func _on_timer_hit_timeout() -> void:
	hit_ttl -= 1
	if hit_ttl % 2 == 0:
		$sprite.material.set_shader_parameter("on", true)
		$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0))
	else:
		$sprite.material.set_shader_parameter("on", false)
		$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0))
		
	if hit_ttl == 0:
		$sprite.material.set_shader_parameter("on", false)
		$sprite.material.set_shader_parameter("color", Color(1.0, 1.0, 1.0))
		$timer_hit.stop()
