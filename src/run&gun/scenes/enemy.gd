extends Area2D
@export var speed: float = 100.0
var life = 1

func _ready() -> void:
	add_to_group("enemies")
	
func hit():
	life -= 1
	if life <= 0:
		die()
		
func die():
	queue_free()

func _physics_process(delta: float) -> void:
	if global_position.x < Global.player_obj.global_position.x:
		$sprite.scale.x = 1
	else:
		$sprite.scale.x = -1

	var direction = (Global.player_obj.global_position - global_position).normalized()
	global_position += direction * speed * delta
