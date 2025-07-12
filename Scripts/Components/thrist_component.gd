@icon("res://Assets/IconGodotNode/node/icon_liquid.png")
extends Node
class_name thrist_component

@onready var diet_stats = owner.stat_sheet.diet_stats
@onready var remaining_thrist : float = diet_stats.thrist
@onready var thrist_timer : Timer
@onready var dehydrated_timer: Timer = %DehydratedTimer

@export_category("Refrences")
@export var action_component : action_component

@export_category("Values")
@export var enabled: bool:
	set(value):
		if thrist_timer:
			thrist_timer.paused = !value

var recently_dranked : bool = false

func _ready() -> void:
	thrist_timer = Timer.new(); thrist_timer.timeout.connect(decay_thrist); thrist_timer.autostart = true; thrist_timer.wait_time = Global.rng.randf_range(0.3, 1)
	add_child(thrist_timer)

func drank():
	recently_dranked = true
	await get_tree().create_timer(120).timeout
	recently_dranked = false

func decay_thrist(amount : float = diet_stats.thrist_decay):
	remaining_thrist = clampi(remaining_thrist - amount, 0, owner.stat_sheet.diet_stats.thrist)
	
	thrist_timer.wait_time = Global.rng.randf_range(0.3, 1)
	
	if remaining_thrist <= 0: dehydrated_timer.start()
	else: dehydrated_timer.stop()
	
	if action_component.current_action.size() != 0: if action_component.current_action["Action"] == "Drink": return
	for action in action_component.queued_actions: if action["Action"] == "Drink": return
	
	if (remaining_thrist / diet_stats.thrist) < diet_stats.thrist_threshold: action_component.queue_up_action("Drink", 0.8)

#TODO add penalty for low thrist
func dehydrated(): pass
