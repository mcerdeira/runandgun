extends Camera2D
var speed = 100
var init = Vector2.ZERO

func _ready() -> void: 
	init = position

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		position.x -= speed * delta
		position.x = max(position.x, -10)
	elif Input.is_action_pressed("right"):
		position.x += speed * delta
		position.x = min(position.x, 10)
	elif Input.is_action_pressed("up"):
		position.y -= speed * delta
		position.y = max(position.y, -10)
	elif Input.is_action_pressed("down"):
		position.y += speed * delta
		position.y = min(position.y, 10)
	else:
		position.y = lerp(position.y, 0.0, 0.1)
		position.x = lerp(position.x, 0.0, 0.1)
