@icon("res://Assets/IconGodotNode/control/icon_tree.png")
extends StaticBody2D
class_name food_producer

@export_category("Values")
@export var food_scene : PackedScene
@export var production_time : int = 10

@onready var timer : Timer = Timer.new()

var potential_spawns : Array[Marker2D]

func _ready() -> void:
	timer.timeout.connect(spawn_food)
	timer.autostart = true
	timer.wait_time = production_time + Global.rng.randf_range(-10, 10)
	add_child(timer)
	
	spawn_food()

func spawn_food():
	potential_spawns.clear(); for child in %Spawns.get_children(): potential_spawns.append(child)
	
	var food = food_scene.instantiate()
	
	#Choose spawn_node and check if it is already in use, if so then pick a new one, if all are in use then return func
	var spawn_node = potential_spawns.pick_random()
	while spawn_node.get_child_count() > 0:
		potential_spawns.erase(spawn_node); spawn_node = potential_spawns.pick_random()
		
		if potential_spawns.size() == 0: return
	
	food.position = spawn_node.position
	
	spawn_node.add_child(food)
	
	timer.wait_time = production_time + Global.rng.randf_range(-10, 10)
