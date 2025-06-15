extends Area2D

@export var speed: float = 1200.0
var direction: Vector2 = Vector2.ZERO

func setmy_scale(_scale):
	$sprite.scale.x = _scale

func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta
