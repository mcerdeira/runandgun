extends CanvasLayer
var textfx = preload("res://scenes/text_replicator.tscn")

func _ready() -> void:
	$Cross2.visible = true
	$life_bar_in.visible = false
	$life_bar_frame.visible = false
	$xp_bar_in.visible = false
	$xp_bar_frame.visible = false
	$lbl_health.visible = false
	$lbl_score.visible = false
	$lbl_xp.visible = false
	Global.gameman_obj = self
	if Global.skip_animation:
		delete_todo()
	else:
		$AnimationPlayer.play("new_animation")
	
func delete_todo():
	Global.player_obj.dont_move = false
	$Cross2.queue_free()
	$life_bar_in.visible = true
	$life_bar_frame.visible = true
	$xp_bar_in.visible = true
	$xp_bar_frame.visible = true
	$lbl_health.visible = true
	$lbl_score.visible = true
	$lbl_xp.visible = true

func _process(delta: float) -> void:
	$lbl_xp.text = "Lvl " + str(Global.current_level + 1)
	$life_bar_in.scale.x = calc_life()
	$xp_bar_in.scale.x = calc_level()

func calc_life():
	return Global.current_life / Global.total_life

func calc_level():
	return Global.current_level_val / Global.levels_vals[Global.current_level]

func create_message(msg):
	var tfx = textfx.instantiate()
	tfx.global_position = Vector2(282, 25)
	tfx.text = msg
	add_child(tfx)
