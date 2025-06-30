@icon("res://Assets/IconGodotNode/node/icon_character.png")
extends CharacterBody2D
class_name base_npc

@export var stat_sheet : StatSheet

func _physics_process(_delta):
	if !stat_sheet : return
