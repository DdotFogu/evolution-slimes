extends Node2D

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", 30, 1)
