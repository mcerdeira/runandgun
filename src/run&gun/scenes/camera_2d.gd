extends Camera2D
@export var player_path: NodePath
var player: Node2D
var max_x := 0.0
var min_y := 0.0
var follow = true
var initial_offset_y := 0.0

func _ready():
	Global.shaker_obj.camera = self
	player = get_node(player_path)
	max_x = player.global_position.x
	initial_offset_y = position.y - player.global_position.y

func _process(delta):
	if follow:
		var target_x = player.global_position.x

		if target_x > max_x:
			max_x = target_x

		position.x = max_x
		Global.max_x = max_x

func followY():
	position.y = lerp(position.y, player.global_position.y + initial_offset_y, 0.1)
