@icon("res://Assets/IconGodotNode/node/icon_meat.png")
extends CharacterBody2D
class_name base_food

@export_category("Values")
@export var edible : bool = false
@export var grow_time : int = 10
@export var life_time : int = 10
@export var rot_time : int = 5
@export var hunger_restoration : int = 9999

func _ready() -> void:
	%SpriteComponent.scale = Vector2(0.1, 0.1)
	await create_tween().tween_property(%SpriteComponent, "scale", Vector2.ONE, grow_time).finished
	edible = true
	
	await create_tween().tween_property(%SpriteComponent, "modulate", Color.SADDLE_BROWN, life_time).finished
	edible = false
	
	await get_tree().create_timer(rot_time).timeout
	queue_free()
