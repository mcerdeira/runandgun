extends Area2D
var activated = false
var spawn_ttl_total = 6.0
var spawn_ttl = 0.0
@export var wavecount = 1
@export var KIND = "all"
@export var zone = "UP"
@export var stopcamera = false
@export var fixedside = -1
var waves = 1

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		if stopcamera:
			Global.shaker_obj.camera.follow = false
		activated = true

func _physics_process(delta: float) -> void:
	if activated:
		if global_position.distance_to(Global.player_obj.global_position) < Global.ONE_SCREEN / 3:
			queue_free()
		if spawn_ttl > 0:
			spawn_ttl -= 1 * delta
			
		spawn()
		if waves > wavecount:
			if stopcamera:
				Global.shaker_obj.camera.follow = true
				Global.shaker_obj.camera.forcehand()
				Global.killemall()
			queue_free()
			
func chooseDir(_zone):
	if fixedside == -1:
		return Global.pick_random(_zone)
	else:
		return _zone[fixedside]

func spawn():
	if spawn_ttl <= 0:
		waves+= 1
		spawn_ttl = spawn_ttl_total
		var enemy = Global.getenemy_random(KIND)
		if zone == "UP":
			var pos = chooseDir(Global.EnemyZoneUp)
			enemy.global_position = pos.global_position
			enemy.direction = pos.direction
		elif zone == "BOTTOM":
			var pos = chooseDir(Global.EnemyZoneBottom)
			enemy.global_position = pos.global_position
			enemy.direction = pos.direction
		elif zone == "MID" or zone == "MIDDLE": 
			var pos = chooseDir(Global.EnemyZoneMid)
			enemy.global_position = pos.global_position
			enemy.direction = pos.direction
		
		get_parent().add_child(enemy)
