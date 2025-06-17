extends Node2D
var spark_obj = preload("res://sprites/spark.tscn")

func _ready() -> void:
	Global.shaker_obj.shake(2.0, 1.0)
	rotation_degrees = randi() % 361
	var spark = spark_obj.instantiate()
	spark.global_position = global_position
	get_parent().add_child(spark)

func _process(delta: float) -> void:
	scale.x -= 100 * delta
	scale.y += 2500 * delta
	if scale.x <= 0.1:
		scale.x = 0.1
	if scale.y >= 500:
		queue_free()
	
