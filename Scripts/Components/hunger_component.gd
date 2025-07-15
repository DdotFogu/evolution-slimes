@icon("res://Assets/IconGodotNode/node_3D/icon_meat.png")
extends Node
class_name hunger_component

enum HungerStates {Full, Hungry, Straving}

@onready var diet_stats = owner.stat_sheet.diet_stats
@onready var remaining_hunger : float = diet_stats.hunger
@onready var hunger_timer : Timer
@onready var strave_timer: Timer = %StraveTimer

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
			

var recently_ate : bool = false

func _ready() -> void:
	strave_timer.paused = true
	hunger_timer = Timer.new(); hunger_timer.timeout.connect(decay_hunger); hunger_timer.autostart = true; hunger_timer.wait_time = Global.rng.randf_range(0.5, 1.5)
	add_child(hunger_timer)

func ate():
	recently_ate = true
	await get_tree().create_timer(120).timeout
	recently_ate = false

func decay_hunger(amount : float = diet_stats.hunger_decay):
	remaining_hunger = clampi(remaining_hunger - amount, 0, owner.stat_sheet.diet_stats.hunger)
	
	hunger_timer.wait_time = Global.rng.randf_range(0.5, 1.5)
	
	if remaining_hunger <= 0: strave_timer.paused = false
	else: strave_timer.paused = true
	
	if action_component.current_action.size() != 0: if action_component.current_action["Action"] == "Eat": return
	for action in action_component.queued_actions: if action["Action"] == "Eat": return
	
	if (remaining_hunger / diet_stats.hunger) < diet_stats.hunger_threshold: action_component.queue_up_action("Eat", 0.8)

func strave():health_component.take_damage(1)
