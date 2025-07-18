extends Camera2D
@export var player_path: NodePath
var player: Node2D
var max_x := 0.0
var min_y := 0.0
var follow = true
var initial_offset_y := 0.0
var show_hand_ttl_total = 13.0
var show_hand_ttl = show_hand_ttl_total
var prev_x = 0

func _ready():
	Global.shaker_obj.camera = self
	player = get_node(player_path)
	max_x = player.global_position.x
	initial_offset_y = position.y - player.global_position.y

func _process(delta):
	if follow:
		var target_x = player.global_position.x
		if target_x == prev_x:
			if get_tree().get_nodes_in_group("enemies").size() == 0:
				if !$Goanim.is_playing():
					show_hand_ttl -= 1 * delta
					if show_hand_ttl <= 0:
						show_hand_ttl = show_hand_ttl_total
						$Goanim.play("new_animation")
		else:
			show_hand_ttl = show_hand_ttl_total
			if $Goanim.is_playing():
				$Goanim.stop(true)
				var tweener = get_tree().create_tween()
				tweener.tween_property($Hand, "position:x", -1000, 0.1)
		
		prev_x = target_x

		if target_x > max_x:
			max_x = target_x

		position.x = max_x
		Global.max_x = max_x
	else:
		show_hand_ttl = show_hand_ttl_total

func followY():
	position.y = lerp(position.y, player.global_position.y + initial_offset_y, 0.1)
