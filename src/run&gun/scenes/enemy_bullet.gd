extends Area2D
var spark_obj = preload("res://sprites/spark.tscn")
var done = false
var spr : AnimatedSprite2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("enemy_bullet")
	spr = $sprite

func setmy_scale(_scale):
	scale.x = _scale
	
func explode(die):
	var spark = spark_obj.instantiate()
	spark.global_position = global_position
	get_parent().add_child(spark)
	if die:
		queue_free()

func _physics_process(delta):
	Global.deletefromdistance(global_position, self)
	
	spr.rotation_degrees += 10 * delta
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta
		if !done:
			done = true
			explode(false)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		explode(true)

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		body.hit()
		explode(true)
