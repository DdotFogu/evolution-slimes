@icon("res://Assets/IconGodotNode/node/icon_scene.png")
extends Node2D
class_name map_manager

@export var ground_tilemap : TileMapLayer
@export var water_tilemap : TileMapLayer

@onready var creatures: Node2D = $"../Ysort/Creatures"

#func _ready() -> void: create_world()

#clears entire world
func destory_world(): 
	ground_tilemap.clear(); water_tilemap.clear()
	for child in creatures.get_children(): child.queue_free()

#create brand new world
func create_world(size := Vector2(10, 10), population : int = 2):
	destory_world(); create_island(size)
	create_slime_pop(population)

func create_slime_pop(amount : int = 2):
	var rect = ground_tilemap.get_used_rect()
	for i in amount:
		#create random position on map for slime instance
		var spawn_pos = ground_tilemap.map_to_local(Vector2i(
			Global.rng.randi_range(0, rect.size.x - 3),
			Global.rng.randi_range(0, rect.size.y - 3),
		))
		
		var slime_instance = preload("res://Scenes/Characters/Slimes/slime.tscn").instantiate()
		slime_instance.global_position = spawn_pos
		get_tree().current_scene.add_child(slime_instance)

func create_island(size := Vector2(10, 10)):
	# Create the ground
	var terrain_array : Array
	for x in size.x:
		for y in size.y:
			var tile_pos = Vector2i(x, y)
			ground_tilemap.set_cell(tile_pos, 0, Vector2i(5, 5), 0)
			terrain_array.append(Vector2i(x, y))
	
	ground_tilemap.set_cells_terrain_connect(terrain_array, 0, 0, true)
	
	# Create the water
	for x in size.x:
		var tile_pos = Vector2i(x, size.y)
		water_tilemap.set_cell(tile_pos, 0, Vector2i(5, 7), 0)
	water_tilemap.set_cell(Vector2(-1, size.y), 0, Vector2(4, 7), 0)
	water_tilemap.set_cell(Vector2(size.x, size.y), 0, Vector2(6, 7), 0)
