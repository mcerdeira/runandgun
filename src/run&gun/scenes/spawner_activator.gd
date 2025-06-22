extends Area2D
@export var value = true

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		Global.shaker_obj.camera.follow = false
		#Global.EnemySpawnerMain.On = value
		#queue_free()
