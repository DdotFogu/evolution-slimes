@icon("res://Assets/IconGodotNode/node/icon_liquid.png")
extends Node
class_name thrist_component

@onready var remaining_thrist : int = owner.stat_sheet.diet_stats.thrist
@onready var thirst_timer : Timer

@export_category("Refrences")
@export var action_component : action_component

@export_category("States")
@export var thristy_state : State

@export_category("Values")
@export var enabled: bool:
	set(value):
		if thirst_timer:
			thirst_timer.paused = !value
@export var thrist_decay_time : float = 5.0
@export var thrist_states := {
	5 : "Quenched",
	4 : "Quenched",
	3 : "Thirsty",
	2 : "Thirsty",
	1 : "Thirsty",
	0 : "Dehydrated"
}

func _ready() -> void:
	var thirst_timer = Timer.new()
	thirst_timer.timeout.connect(decay_thrist)
	thirst_timer.autostart = true
	thirst_timer.wait_time = thrist_decay_time
	add_child(thirst_timer)

func decay_thrist(amount : int = 1):
	remaining_thrist = clampi(remaining_thrist - amount, 0, owner.stat_sheet.diet_stats.thrist)
	
	match thrist_states[remaining_thrist]:
		"Thirsty": action_component.queue_up_action("Drink", 0.8)
		"Dehydrated": action_component.queue_up_action("Drink", 0.9)
