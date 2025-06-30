@icon("res://Assets/IconGodotNode/node_3D/icon_meat.png")
extends Node
class_name hunger_component

enum HungerStates {Full, Hungry, Straving}

@onready var remaining_hunger : int = owner.stat_sheet.hunger
@onready var hunger_timer : Timer

@export_category("Refrences")
@export var vision_component : vision_component
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

var looking_for_food : bool = false

signal hungry
signal eat

func _ready() -> void:
	var hunger_timer = Timer.new()
	hunger_timer.timeout.connect(decay_hunger)
	hunger_timer.autostart = true
	hunger_timer.wait_time = hunger_decay_time
	add_child(hunger_timer)

func decay_hunger(amount : int = 1):
	remaining_hunger = clampi(remaining_hunger - amount, 0, owner.stat_sheet.hunger)
	
	if looking_for_food == false:
		match hunger_states[remaining_hunger]:
			"Hungry":
				go_to_food()
			"Straving":
				go_to_food()
				strave()
	
	if remaining_hunger <= 0: strave()

#TODO make func acutally search for nearest source // right now it only picks random
#find best food source
func search_for_food() -> Node2D:
	var closest_food = vision_component.sort_objects(["Food"])
	if closest_food.size() == 0: return null
	closest_food = closest_food["Food"].pick_random()
	
	return closest_food

func go_to_food():
	looking_for_food = true
	
	#start travel towards nearest food source
	var closest_food := search_for_food()
	if closest_food == null: return
	
	hungry_state.goto_position = closest_food.global_position
	hungry.emit()
	
	#wait until in range of tree to begin eating
	await hungry_state.finished
	
	#begin eat process
	eat.emit()

func strave():
	health_component.take_damage(1)
