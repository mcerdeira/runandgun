extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var col : CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
	polygon = col.polygon
