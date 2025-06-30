@icon("res://Assets/IconGodotNode/node/icon_visibility.png")
extends Node2D
class_name vision_component

@export_category("Values")
@export var enabled : bool = true
@export_flags_2d_physics var searchable_items

var vision : Dictionary
@onready var vision_range : float = owner.stat_sheet.vision_range
@onready var vision_node : Area2D = %VisionNode

func _process(delta: float) -> void:
	vision_range = owner.stat_sheet.vision_range
	if enabled:
		vision_node.get_node("Range").shape.radius = vision_range
		vision_node.collision_mask = searchable_items
		vision = find_objects()

func find_objects() -> Dictionary:
	if not enabled:
		return {}
	
	var seeable_objects: Dictionary = {}
	
	for object in vision_node.get_overlapping_bodies():
		if object.is_in_group("Food"):
			if not seeable_objects.has("Food"):
				seeable_objects["Food"] = []
			seeable_objects["Food"].append(object)
	
	return seeable_objects

func sort_objects(types: Array[String]) -> Dictionary:
	var sorted_vision: Dictionary
	for t in types:
		if vision.has(t): sorted_vision[t] = vision[t]
	return sorted_vision

func in_range(object : Node2D) -> bool:
	if !%VisionNode.overlaps_body(object): return false
	elif %VisionNode.overlaps_body(object): return true
	
	return false
