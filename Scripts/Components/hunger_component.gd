@icon("res://Assets/IconGodotNode/node_3D/icon_meat.png")
extends Node
class_name hunger_component

enum HungerStates {Full, Hungry, Straving}

@onready var remaining_hunger : int = owner.stat_sheet.diet_stats.hunger
@onready var hunger_timer : Timer

@export_category("Refrences")
@export var action_component : action_component
@export var health_component : health_component

@export_category("States")
@export var hungry_state : State

@export_category("Values")
@export var enabled: bool:
	set(value):
		if hunger_timer:
			hunger_timer.paused = !value
@export var hunger_decay_time : float = 5.0
@export var hunger_states := {
	5 : "Full",
	4 : "Full",
	3 : "Hungry",
	2 : "Hungry",
	1 : "Hungry",
	0 : "Straving"
}

func _ready() -> void:
	var hunger_timer = Timer.new(); hunger_timer.timeout.connect(decay_hunger); hunger_timer.autostart = true; hunger_timer.wait_time = hunger_decay_time
	add_child(hunger_timer)

func decay_hunger(amount : int = 1):
	remaining_hunger = clampi(remaining_hunger - amount, 0, owner.stat_sheet.diet_stats.hunger)
	
	match hunger_states[remaining_hunger]:
		"Hungry": action_component.queue_up_action("Eat", 0.8)
		"Straving": action_component.queue_up_action("Eat", 0.9); strave()

func strave(): health_component.take_damage(1)
