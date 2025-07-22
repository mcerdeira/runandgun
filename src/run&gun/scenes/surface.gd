extends Sprite2D

class_name paint

var bloods = []
var blood_texture =  preload("res://sprites/blood.png")
var blood_texture_player =  preload("res://sprites/blood_player.png")
var blood_type = ""
var blood_limit = 35000
		
func draw_blood(draw_pos : Vector2, _blood_type):
	blood_type = _blood_type
	if bloods.size() > blood_limit:
		bloods.pop_front()
		bloods.push_back(draw_pos)
	else:
		bloods.append(draw_pos)
	queue_redraw()
		
func _draw():
	for b in bloods:
		if blood_type == "blood":
			draw_texture(blood_texture, b)
		if blood_type == "blood_player":
			draw_texture(blood_texture_player, b)
