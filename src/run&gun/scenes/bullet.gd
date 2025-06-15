extends Area2D
var spark_obj = preload("res://sprites/spark.tscn")
var done = false
var ttl = 0.5

@export var speed: float = 1200.0
var direction: Vector2 = Vector2.ZERO

func setmy_scale(_scale):
	scale.x = _scale

func _physics_process(delta):
	if direction != Vector2.ZERO:
		ttl -= 1 * delta
		if ttl <= 0:
			visible = false
			var spark = spark_obj.instantiate()
			spark.global_position = global_position
			get_parent().add_child(spark)
			
			queue_free()
		position += direction.normalized() * speed * delta
		if !done:
			done = true
			var spark = spark_obj.instantiate()
			spark.global_position = global_position
			get_parent().add_child(spark)
