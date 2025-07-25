extends Sprite2D

class_name paint

var bloods = []
var blood_texture =  preload("res://sprites/blood.png")
var blood_texture_player =  preload("res://sprites/blood_player.png")
var blood_limit = 3500
		
func draw_blood(draw_pos : Vector2, _blood_type):
	if bloods.size() > blood_limit:
		bloods.pop_back()
		bloods.push_back([draw_pos, _blood_type])
	else:
		bloods.append([draw_pos, _blood_type])
	queue_redraw()
		
func _draw():
	for b in bloods:
		if b[0].x + 1152 < Global.max_x:
			bloods.pop_front()
		else:
			if b[1] == "blood":
				draw_texture(blood_texture, b[0])
			if b[1] == "blood_player":
				draw_texture(blood_texture_player, b[0])
