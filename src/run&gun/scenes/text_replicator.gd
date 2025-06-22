extends Node2D

@export var text := "DEAD MAN"
@export var font: Font
@export var font_size := 150
@export var layer_count := 20
@export var layer_offset := Vector2(0, 2)
@export var base_color := Color.BLACK        # Color del eco
@export var outline_size := 2
@export var outline_color := Color.BLACK
var ended = false

var cursor = 0
var labels = []
var ttl = 0.5

func _ready():
	# Eliminar Labels anteriores si recargás la escena
	for child in get_children():
		if child is Label:
			child.queue_free()

	# LabelSettings compartido para todos
	var label_settings := LabelSettings.new()
	label_settings.font = font
	label_settings.font_size = font_size
	label_settings.outline_size = outline_size
	label_settings.outline_color = outline_color
	label_settings.font_color = base_color

	# Crear las capas (eco)
	for i in range(layer_count):
		var l := Label.new()
		l.text = text
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.label_settings = label_settings
		l.position = layer_offset * i
		l.z_as_relative = false
		l.visible = false
		labels.append(l)
		add_child(l)
	
func _physics_process(delta: float) -> void:
	if ended:
		ttl -= 1 * delta
		if ttl <= 0:
			queue_free()
	else:
		labels[cursor].visible = true
		cursor += 1
		if cursor >= labels.size() - 1:
			ended = true
