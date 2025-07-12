@icon("res://Assets/IconGodotNode/node/icon_dice.png")
extends Node2D
class_name seed

@export var seedName := ""
var seedToUse : int

func _ready() -> void:
	randomize()
	
	if seedName:
		seedToUse = hash(seedName)
	else:
		seedToUse = randi()
	
	seed(seedToUse)
	print(seedToUse, " is the seed being used" )
