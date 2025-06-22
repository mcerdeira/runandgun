extends Node2D
var enemy_obj = preload("res://scenes/enemy.tscn")

func _ready() -> void:
	Global.EnemySpawnerMain.spawners.append(self)

func spawn():
	var enemy = enemy_obj.instantiate()
	enemy.global_position = global_position
	get_parent().get_parent().add_child(enemy)
