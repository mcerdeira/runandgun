extends Node2D
var activated = false
var spawn_ttl_total = 3.0
var spawn_ttl = 0.0
var count = 0
@export var KIND = "all"

func _physics_process(delta: float) -> void:
	if !activated:
		if global_position.distance_to(Global.player_obj.global_position) < Global.ONE_SCREEN:
			activated = true
	else:
		if global_position.distance_to(Global.player_obj.global_position) < Global.ONE_SCREEN / 3:
			queue_free()
		if spawn_ttl > 0:
			spawn_ttl -= 1 * delta
			
		spawn()

func spawn():
	if spawn_ttl <= 0:
		count += 1
		spawn_ttl = spawn_ttl_total
		var enemy = Global.getenemy_random(KIND)
		if count > Global.MAX_SPAWN_XP:
			enemy.no_xp = true
		enemy.global_position = global_position
		get_parent().add_child(enemy)
