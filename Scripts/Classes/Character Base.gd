@icon("res://Assets/IconGodotNode/node/icon_character.png")
extends CharacterBody2D
class_name base_npc

@export var stat_sheet : StatSheet

var parents : Dictionary
var children : Array

func _ready() -> void:
	print("Skune ")
	Global.population_count += 1

func _physics_process(_delta): 
	if !stat_sheet : return
