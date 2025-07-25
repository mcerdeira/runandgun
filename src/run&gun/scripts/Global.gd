extends Node
var shaker_obj = null
var player_obj = null
var gameman_obj = null
var skip_animation = false
var GAMEOVER = false
var FULLSCREEN = false
## Enemies ################################
var ENEMIES = []
var ENEM_FLYERS = []
var ENEM_WALKERS = []
var ENEMY_BAT = null
var ENEMY_EYE = null
var ENEMY_WALKER = null
## Leveling stuff ########################
var current_level = 0.0
var current_level_val = 0.0
var levels_vals = [20.0, 55.0, 100.0, 150.0]
var current_life = 50.0
var total_life = 50.0
var shoot_delay_total = 0.3
var bullet_ttl = 1.0
var bullet_count = 1
#######################################
var max_x = null
var ONE_SCREEN = 1250
var MAX_SPAWN_XP = 5
var MAIN_THEME = null

func init_vars():
	MAIN_THEME = load("res://music/Night On Bald Mountain.mp3")
	ENEMY_BAT = preload("res://scenes/enemy.tscn")
	ENEMY_EYE = preload("res://scenes/enemy_eye.tscn")
	ENEMY_WALKER = preload("res://scenes/enemy_walker.tscn")
	ENEM_FLYERS = [
		ENEMY_BAT, 
		ENEMY_EYE,
	]
	ENEM_WALKERS = [
		ENEMY_WALKER
	]
	
	ENEMIES = [
		ENEMY_BAT, 
		ENEMY_EYE,
		ENEMY_WALKER
	]
	
func getenemy_random(kind):
	var en = null
	if kind == "all":
		en = Global.pick_random(ENEMIES)
	elif kind == "flyers":
		en = Global.pick_random(ENEM_FLYERS)
	elif kind == "warlkers":
		en = Global.pick_random(ENEM_WALKERS)
	elif kind == "eye":
		en = ENEMY_EYE
	elif kind == "bat":
		en = ENEMY_BAT
	elif kind == "walker":
		en = ENEMY_WALKER
		
	return en.instantiate()

func _ready():
	RenderingServer.set_default_clear_color(Color8(36, 15, 28))
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	init_vars()
	Music.play(MAIN_THEME, 0.0)
	
func level_down(dmg):
	Global.current_level_val -= dmg
	if Global.current_level_val < 0.0:
		Global.current_level_val = 0.0
		
	if Global.current_level_val <= 0 and Global.current_level > 0.0:
		Global.current_level -= 1.0
		Global.gameman_obj.create_message("LEVEL DOWN!")
		Global.current_level_val = Global.levels_vals[Global.current_level] - dmg
		if Global.current_level < 0:
			Global.current_level = 0.0
	
func level_up(val):
	if Global.current_level + 1 <= Global.levels_vals.size():
		Global.current_level_val += val
		if Global.current_level_val >= Global.levels_vals[Global.current_level]:
			Global.gameman_obj.create_message("LEVEL UP!")
			killemall()
			Global.shaker_obj.shake(10.0, 3.0)
			Global.current_level += 1.0
			Global.current_level_val = 0.0
			return true
		else:
			return false
	else:
		return false
		
func killemall():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var bullets = get_tree().get_nodes_in_group("enemy_bullet")
	for e in enemies:
		e.die(false)
		
	for b in bullets:
		b.explode(true)
	
func deletefromdistance(_global_position, obj):
	if _global_position.distance_to(Global.player_obj.global_position) > ONE_SCREEN:
		obj.queue_free()
	
func _physics_process(delta: float) -> void:		
	if Input.is_action_just_pressed("toggle_fullscreen"):
		Global.FULLSCREEN = !Global.FULLSCREEN
		if Global.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			return

func emit(_global_position, count, particle_obj = null, size = 1):
	var part = particle_obj
	for i in range(count):
		var p = part.instantiate()
		p.global_position = _global_position
		p.size = size
		add_child(p)
	
func pick_random(container):
	if typeof(container) == TYPE_DICTIONARY:
		return container.values()[randi() % container.size() ]
	assert( typeof(container) in [
			TYPE_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_INT32_ARRAY,
			TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_STRING_ARRAY,
			TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY
			], "ERROR: pick_random" )
	return container[randi() % container.size()]

func play_sound(stream: AudioStream, options:= {}, _global_position = null, delay = 0.0) -> AudioStreamPlayer:
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS

	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.bus = "SFX"
	
	for prop in options.keys():
		audio_stream_player.set(prop, options[prop])
		
	if delay > 0.0:
		var timer = Timer.new()
		timer.wait_time = delay
		timer.one_shot = true
		timer.connect("timeout", audio_stream_player.play)
		add_child(timer)
		timer.start()
	else:
		audio_stream_player.play()
		
	audio_stream_player.finished.connect(kill.bind(audio_stream_player))
	
	return audio_stream_player
	
func kill(_audio_stream_player):
	if _audio_stream_player and is_instance_valid(_audio_stream_player):
		_audio_stream_player.queue_free()

func is_ok_FX(pos):
	return true
