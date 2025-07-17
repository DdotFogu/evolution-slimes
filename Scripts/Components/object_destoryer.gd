extends Area2D
class_name object_destoryer

@export var enabled : bool = true

func destory_objects_in_area(skip : bool = false):
	if !enabled: return
	
	for node in get_overlapping_bodies(): 
		
		if !skip:
			var scale_tween = get_tree().create_tween()
			scale_tween.tween_property(node, "scale", Vector2.ZERO, 0.5)
		
		if !node: return
		node.queue_free()
