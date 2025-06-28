extends Area2D
var activated = false
var spawn_ttl_total = 3.0
var spawn_ttl = 0.0
var count = 0

func _physics_process(delta: float) -> void:
	if activated:
		Global.deletefromdistance(global_position, self)
		if spawn_ttl > 0:
			spawn_ttl -= 1 * delta
			
		spawn()

func spawn():
	if spawn_ttl <= 0:
		count += 1
		spawn_ttl = spawn_ttl_total
		var enemy = Global.getenemy_random()
		if count > Global.MAX_SPAWN_XP:
			enemy.no_xp = true
		enemy.global_position = global_position
		get_parent().add_child(enemy)

func _on_body_exited(body: Node2D) -> void:
	makeactive(body)

func makeactive(body):
	if body and body.is_in_group("players") and !activated:
		activated = true
