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
var force_ttl = 0.0

func _ready():
	Global.shaker_obj.camera = self
	player = get_node(player_path)
	max_x = player.global_position.x
	initial_offset_y = position.y - player.global_position.y
	Global.EnemyZoneUp = [$EnemyZoneUp/mark1, $EnemyZoneUp/mark2]
	Global.EnemyZoneMid = [$EnemyZoneMid/mark1, $EnemyZoneMid/mark2]
	Global.EnemyZoneBottom = [$EnemyZoneBottom/mark1, $EnemyZoneBottom/mark2]
	
func forcehand():
	$Goanim.play("new_animation")
	force_ttl = 3.0

func _process(delta):
	if Input.is_action_just_pressed("debug_zoom_in"):
		zoom.x += 0.1
		zoom.y = zoom.x
		
	if Input.is_action_just_pressed("debug_zoom_out"):
		zoom.x -= 0.1
		zoom.y = zoom.x
		
	if force_ttl > 0.0:
		force_ttl -= 1 * delta
	
	if follow and force_ttl <= 0:
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
