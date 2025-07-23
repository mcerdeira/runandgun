extends RigidBody2D
@export var lifetime := 2.0 
var dir = 0
var xp_item_fx = preload("res://scenes/xp_item_fx.tscn")

func _ready():
	randomize()
	apply_central_impulse(Vector2(randi_range(0, 200) * dir, Global.pick_random([-100, -200, -300, -400, -500, -600, -900]) )) 
	
func _physics_process(delta: float) -> void:
	if global_position.x + 1152 < Global.max_x:
		queue_free()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		gravity_scale = 0.0
		var xp = xp_item_fx.instantiate()
		xp.global_position = global_position
		body.xp_up()
		get_parent().add_child(xp)
		queue_free()
