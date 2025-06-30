@icon("res://Assets/IconGodotNode/node/icon_scene.png")
extends vision_component
class_name action_component

func _process(delta: float) -> void:
	vision_range = owner.stat_sheet.action_range
	if enabled:
		vision_node.get_node("Range").shape.radius = vision_range
		vision_node.collision_mask = searchable_items
		vision = find_objects()
