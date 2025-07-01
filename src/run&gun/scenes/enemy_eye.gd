extends Area2D
var speed: float = 100.0
var xp_drop = preload("res://scenes/xp_item.tscn")
var bullet_obj = preload("res://scenes/enemy_bullet.tscn")
var life = 3
var shoot_ttl_total = 3.0
var shoot_ttl = 3.0
var no_xp = false

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
		
	var direction = Vector2.LEFT
	global_position += direction * speed * delta
		
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		body.hit()
