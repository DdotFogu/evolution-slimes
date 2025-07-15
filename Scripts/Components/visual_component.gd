@icon("res://Assets/IconGodotNode/node/icon_character.png")
extends Node2D
class_name visual_componet

@export var cosmetics : Dictionary

@onready var stat_sheet : StatSheet = owner.stat_sheet

func _ready() -> void: 
	if stat_sheet == null: return
	
	if stat_sheet.mating_stats.gender == 1: show_item("FAttena")
	if stat_sheet: modulate = stat_sheet.character_color

func show_item(item_name : String, enabled : bool = true):
	get_node(cosmetics[item_name]).visible = enabled
