extends Area2D
var spark_obj = preload("res://sprites/spark.tscn")
var done = false
var ttl = Global.bullet_ttl

@export var speed: float = 1200.0
var direction: Vector2 = Vector2.ZERO

func setmy_scale(_scale):
	scale.x = _scale
	
func explode(die):
	var spark = spark_obj.instantiate()
	spark.global_position = global_position
	get_parent().add_child(spark)
	if die:
		queue_free()

func _physics_process(delta):
	if direction != Vector2.ZERO:
		ttl -= 1 * delta
		if ttl <= 0:
			visible = false
			explode(true)
			
		position += direction.normalized() * speed * delta
		if !done:
			done = true
			explode(false)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		explode(true)
