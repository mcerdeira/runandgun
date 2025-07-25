extends Area2D
var speed: float = 100.0
var xp_drop = preload("res://scenes/xp_item.tscn")
var bullet_obj = preload("res://scenes/enemy_bullet.tscn")
var life = 2
var shoot_ttl_total = 3.0
var shoot_ttl = 3.0
var no_xp = false
var direction = -1
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
		
func die():
	var dir = 1
	if !no_xp and Global.pick_random([true, false]):
		for i in range(2):
			var xp = xp_drop.instantiate()
			xp.dir = dir
			xp.global_position = global_position
			dir *= -1
			get_parent().add_child(xp)
	bleed(15)
	queue_free()

func shoot():
	var bullet = bullet_obj.instantiate()
	bullet.global_position = global_position
	bullet.direction = (Global.player_obj.global_position - global_position).normalized()
	get_parent().add_child(bullet)

func _physics_process(delta: float) -> void:
	Global.deletefromdistance(global_position, self)
	shoot_ttl -= 1 * delta
	if shoot_ttl <= 0:
		shoot_ttl = shoot_ttl_total
		shoot()
		
	$sprite.scale.x = direction * -1
	global_position += Vector2(direction, 0) * speed * delta
		
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		body.hit()

func _on_hit_timer_timeout() -> void:
	$sprite.material.set_shader_parameter("on", false)

func bleed(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		get_parent().call_deferred("add_child", blood_instance)
