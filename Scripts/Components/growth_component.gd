@icon("res://Assets/IconGodotNode/node/icon_potion.png")
extends Node
class_name growth_component

@onready var growth_stats : GrowthStats = owner.stat_sheet.growth_stats 
@onready var grow_timer: Timer = $GrowTimer

var _growth: float = 0.0

var growth: float:
	get:
		return _growth
	set(value):
		_growth = clamp(value, 0.0, 1.0)

func _ready() -> void: growth += growth_stats.inital_growth

func increase_growth(amount : float = growth_stats.growth_speed):
	if growth == 1.0: return
	growth += amount
