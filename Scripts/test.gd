extends RayCast2D

func _process(delta: float) -> void:
	if is_colliding(): print("Ddot")
