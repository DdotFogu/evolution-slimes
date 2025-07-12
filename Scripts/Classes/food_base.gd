@icon("res://Assets/IconGodotNode/node/icon_meat.png")
extends CharacterBody2D
class_name base_food

@export_category("Values")
@export var restore_amount : int = 999
@export var edible : bool = false
@export var grow_time : int = 10 

func _ready() -> void:
	grow_time += Global.rng.randf_range(-10, 10)
	
	%SpriteComponent.scale = Vector2(0.1, 0.1)
	await create_tween().tween_property(%SpriteComponent, "scale", Vector2.ONE, grow_time).finished
	edible = true

func eat(consumer : Node2D):
	consumer.get_node("HungerComponent").decay_hunger(-restore_amount)
	queue_free()
