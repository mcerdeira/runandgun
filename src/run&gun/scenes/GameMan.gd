extends CanvasLayer
var textfx = preload("res://scenes/text_replicator.tscn")

func _ready() -> void:
	Global.gameman_obj = self

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
