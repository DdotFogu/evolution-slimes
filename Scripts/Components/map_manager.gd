@icon("res://Assets/IconGodotNode/node/icon_scene.png")
extends Node2D
class_name map_manager

@export var ground_tilemap : TileMapLayer
@export var water_tilemap : TileMapLayer

@onready var creatures: Node2D = $"../Ysort/Creatures"
@onready var food_sources: Node2D = $"../Ysort/Food Sources"
@onready var water_sources: Node2D = $"../Ysort/Water Sources"
@onready var other: Node2D = $"../Ysort/Other"

#clears entire world
func destory_world(): 
	Global.population_count = 0
	ground_tilemap.clear(); water_tilemap.clear()
	for child in creatures.get_children(): child.queue_free()
	for child in food_sources.get_children(): child.queue_free()
	for child in water_sources.get_children(): child.queue_free()
	for child in other.get_children(): child.queue_free()

#create brand new world
func create_world(data : WorldData):
	%CameraComponent.change_position(ground_tilemap.map_to_local(data.world_size / 2), 0.0);%CameraComponent.change_zoom(Vector2(0.4, 0.4) / (max(data.world_size.x, data.world_size.y) / 10), 0.0)
	destory_world(); await create_island(data.world_size)
	create_water_sources(data.water_count); create_food_sources(data.food_count)
	
	#Allow pausing
	%Menu.can_pause = true
	return

func create_food_sources(amount : int):
	for i in amount:
		var source_instance = preload("res://Scenes/Food/producer/fruit_tree.tscn").instantiate()
		
		var spawn_pos = Global.get_pos_in_tilemap(ground_tilemap)
		
		source_instance.global_position = spawn_pos
		
		Global.y_sort.get_node("Food Sources").add_child(source_instance)

func create_water_sources(amount : int):
	for i in amount:
		var source_instance : StaticBody2D = preload("res://Scenes/World/water_source.tscn").instantiate()
		var spawn_pos = Global.get_pos_in_tilemap(ground_tilemap, 10)
		
		source_instance.global_position = spawn_pos
		
		while true:
			if source_instance.get_node("OverlapCheck").has_overlapping_bodies():
				print("diddy") 
				spawn_pos = Global.get_pos_in_tilemap(ground_tilemap, 10)
				source_instance.global_position = spawn_pos
			else: break
		
		Global.y_sort.get_node("Water Sources").add_child(source_instance)

func create_slime_pop(amount: int, stat_sheet: StatSheet) -> void:
	var slime_scene = preload("res://Scenes/Characters/Slimes/MaleSlime.tscn")
	
	for i in range(amount):
		var spawn_pos = Global.get_pos_in_tilemap(ground_tilemap)
		
		#stat_sheet.mating_stats.gender = i % 2
		
		var slime_instance = slime_scene.instantiate()
		slime_instance.stat_sheet = stat_sheet
		slime_instance.global_position = spawn_pos
		
		Global.y_sort.get_node("Creatures").add_child(slime_instance)

func create_island(size := Vector2(10, 10), skip_popup : bool = false):
	#Animated Popup
	if skip_popup == false:
		var instance_array : Array[Node2D]
		var terrain_array : Array[Node2D]
		for x in size.x + 2:
			var terrain_instance = preload("res://Scenes/World/IslandPiece.tscn").instantiate()
			terrain_instance.create_row(Vector2i(x, size.y), size)
			
			var tile_pos = Vector2i(x - 1, size.y)
			terrain_instance.global_position = ground_tilemap.map_to_local(tile_pos)
			Global.y_sort.get_node("Other").add_child(terrain_instance)
			
			instance_array.append(terrain_instance)
		
		for instance in instance_array:
			if !instance: return
			instance.play_popup()
			
			await get_tree().create_timer(0.3 / (size.x / 10)).timeout
		
		await get_tree().create_timer(2.0).timeout
		for instance in instance_array: instance.queue_free()
	
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
	
	return
