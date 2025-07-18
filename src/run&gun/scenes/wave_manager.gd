extends Area2D
var activated = false
var spawn_ttl_total = 3.0
var spawn_ttl = 0.0
@export var KIND = "all"

func _ready() -> void:
	$ColorRect.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		Global.shaker_obj.camera.follow = false
		activated = true

func _physics_process(delta: float) -> void:
	if activated:
		if global_position.distance_to(Global.player_obj.global_position) < Global.ONE_SCREEN / 3:
			queue_free()
		if spawn_ttl > 0:
			spawn_ttl -= 1 * delta
			
		spawn()

func spawn():
	if spawn_ttl <= 0:
		var childs = get_children()
		for c in childs:
			spawn_ttl = spawn_ttl_total
			var enemy = Global.getenemy_random(KIND)
			enemy.global_position = c.global_position
			get_parent().add_child(enemy)
