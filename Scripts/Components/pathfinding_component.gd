@icon("res://Assets/IconGodotNode/node/icon_search.png")
extends Node2D
class_name pathfinding_component

var los = ShapeCast2D.new()
@onready var body : CharacterBody2D = owner

# Fallback memory
var last_direction
var fallback_position: Vector2
var using_fallback: bool = false

func _ready() -> void:
	los.shape = CircleShape2D.new()
	los.shape.radius = 5
	add_child(los)

func los_check(target_pos : Vector2, new_global_position : Vector2 = owner.global_position, mask : int = 2):
	los.visible = true
	los.global_position = new_global_position
	los.collision_mask = mask
	
	los.target_position = target_pos - get_parent().global_position
	los.force_shapecast_update()
	
	if !los.get_collider(0) != null:
		return los.get_collider(0) == null
	else:
		return false

func direction_to_target(target_pos : Vector2):
	var target_direction = body.global_position.direction_to(target_pos).normalized()
	return target_direction

func get_nearby_position(radius : float):
	var rnd_pos : Vector2 = Vector2(Global.rng.randf_range(-150, 150), Global.rng.randf_range(-150, 150))
	if rnd_pos: return rnd_pos
