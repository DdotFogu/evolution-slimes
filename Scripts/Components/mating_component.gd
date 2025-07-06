@icon("res://Assets/IconGodotNode/node/icon_puzzle.png")
extends Node
class_name mating_component

@export_category("Refrences")
@export var hunger_component : hunger_component
@export var thrist_component : thrist_component
@export var action_component : action_component

@onready var mating_stats : MatingStats = owner.stat_sheet.mating_stats

func _ready() -> void:
	#Create timer to decide when male looks for a mate
	if mating_stats.gender == 0: 
		var mate_timer : Timer = Timer.new()
		# the higher the sex drive the less wait time and vice versa
		mate_timer.wait_time = clampi(roundi(514200.0 / pow(mating_stats.sex_drive + 100, 1.71)), 0, 99999); print(mate_timer.wait_time)
		mate_timer.autostart = true
		mate_timer.timeout.connect(find_mate)
		add_child(mate_timer)

func find_mate():
	if should_seek_partner(): action_component.queue_up_action("Mate", 0.1)

func should_seek_partner() -> bool:
	return mating_stats.is_fertile \
	and hunger_component.hunger_states[hunger_component.remaining_hunger] == "Full" \
	and thrist_component.thrist_states[thrist_component.remaining_thrist] == "Quenched"
