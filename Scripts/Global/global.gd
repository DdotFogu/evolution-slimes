extends Node

@onready var rng = RandomNumberGenerator.new()
var current_camera : Camera2D
var y_sort : Node2D
var GameInfo : CanvasLayer
var in_dialouge : bool = false

func _process(delta: float) -> void:
	if get_tree().current_scene != null && get_tree().current_scene.get_node("Ysort") != null: y_sort = get_tree().current_scene.get_node("Ysort")
	current_camera = get_viewport().get_camera_2d()

func change_scene(scene_path : String):
	get_tree().change_scene_to_file(scene_path)

static func get_side_relation(object_1: Node2D, object_2: Node2D) -> int:
	if !object_2: return Global.rng.randi_range(0, 1)
	
	if object_1.global_position.x > object_2.global_position.x:
		return 1  # Object 1 is on the right
	elif object_1.global_position.x < object_2.global_position.x:
		return -1  # Object 1 is on the left
	else:
		return 0  # They are aligned
