extends Node2D

@export var ground_tilemap : TileMapLayer
@export var water_tilemap : TileMapLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Start submerged and hidden
	position += Vector2(0, 42)
	#scale = Vector2(0, 0)

func play_popup():
	animation_player.play("popup")
	
	var tween = get_tree().create_tween()
	
	# Rise up like surfacing from water
	tween.tween_property(self, "position", position - Vector2(0, 32), 1.5)\
		.set_trans(Tween.TRANS_CIRC)\
		.set_ease(Tween.EASE_OUT)

func create_row(tile_pos : Vector2i, world_size : Vector2i):
	
	for i in range(world_size.y):
		ground_tilemap.set_cell(Vector2i(0, -i - 1), 0, Vector2i(5, 5), 0)
		
		#Sides
		if tile_pos.x == 0: ground_tilemap.set_cell(Vector2i(0, -i - 1), 0, Vector2i(4, 5), 0)
		if tile_pos.x == 0: ground_tilemap.set_cell(Vector2i(0, -i), 0, Vector2i(4, 5), 0)
		if tile_pos.x == world_size.x + 1: ground_tilemap.set_cell(Vector2i(0, -i - 1), 0, Vector2i(6, 5), 0)
		if tile_pos.x == world_size.x + 1: ground_tilemap.set_cell(Vector2i(0, -i), 0, Vector2i(6, 5), 0)
	
	#Top and Bottom
	ground_tilemap.set_cell(Vector2i(0, 0), 0, Vector2i(5, 6), 0)
	ground_tilemap.set_cell(Vector2i(0, -world_size.y - 1), 0, Vector2i(5, 4), 0)
	
	#Cornors
	if tile_pos.x == 0: 
		ground_tilemap.set_cell(Vector2i(0, -world_size.y - 1), 0, Vector2i(4, 4), 0)
		ground_tilemap.set_cell(Vector2i(0, 0), 0, Vector2i(4, 6), 0)
	if tile_pos.x == world_size.x + 1: 
		ground_tilemap.set_cell(Vector2i(0, -world_size.y - 1), 0, Vector2i(6, 4), 0)
		ground_tilemap.set_cell(Vector2i(0, 0), 0, Vector2i(6, 6), 0)
