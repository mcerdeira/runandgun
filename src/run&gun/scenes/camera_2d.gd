extends Camera2D
@export var player_path: NodePath
var player: Node2D
var max_x := 0.0
var min_y := 0.0
var follow = true

func _ready():
	Global.shaker_obj.camera = self
	player = get_node(player_path)
	max_x = player.global_position.x

func _process(delta):
	if follow:
		var target_x = player.global_position.x

		if target_x > max_x:
			max_x = target_x

		# Scroll solo hacia derecha y arriba
		position.x = max_x
		Global.max_x = max_x
