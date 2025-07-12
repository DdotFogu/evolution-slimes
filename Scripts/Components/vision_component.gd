@icon("res://Assets/IconGodotNode/node/icon_visibility.png")
extends Node2D
class_name vision_component

@export_category("Refrences")
@export var growth_component : growth_component

@export_category("Values")
@export var enabled : bool = true
@export_flags_2d_physics var searchable_items

var vision : Dictionary = {"Fruit" : []}
@onready var vision_range : float = owner.stat_sheet.action_stats.vision_range
@onready var vision_node : Area2D = %VisionNode

func _ready() -> void: vision_node.get_node("Range").shape = CircleShape2D.new()

func _process(delta: float) -> void:
	
	vision_range = (owner.stat_sheet.action_stats.vision_range * clampf(growth_component.growth + 0.25, 0.0, 1.0))
	if enabled:
		vision_node.get_node("Range").shape.radius = vision_range
		vision_node.collision_mask = searchable_items
		vision = find_objects()

func find_objects() -> Dictionary:
	if not enabled: return {}
	
	var seeable_objects: Dictionary = {}
	
	for object in vision_node.get_overlapping_bodies():
		var groups = object.get_groups()
		if groups.size() > 0: if not seeable_objects.has(str(groups[0])):
			seeable_objects[str(groups[0])] = []
		if groups.size() > 0: seeable_objects[str(groups[0])].append(object)
	
	return seeable_objects

#TODO make func acutally search for nearest source // right now it only picks random
#find best food source
func closest_source(type : String = "Fruit") -> Node2D:
	var source = sort_objects([type])
	if source.size() == 0: return null
	source = source[type].pick_random()
	
	if !source: return null
	return source

func sort_objects(types: Array[String]) -> Dictionary:
	var sorted_vision: Dictionary
	for t in types: if vision.has(t): sorted_vision[t] = vision[t]
	return sorted_vision

func in_range(object : Node2D) -> bool:
	if !%VisionNode.overlaps_body(object): return false
	elif %VisionNode.overlaps_body(object): return true
	
	return false
