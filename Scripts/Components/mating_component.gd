@icon("res://Assets/IconGodotNode/node/icon_puzzle.png")
extends Node
class_name mating_component

@export_category("Refrences")
@export var hunger_component : hunger_component
@export var thrist_component : thrist_component
@export var growth_component : growth_component
@export var action_component : action_component

@onready var mating_stats : MatingStats = owner.stat_sheet.mating_stats
@onready var mate_timer : Timer = Timer.new()

func _ready() -> void:
	#Create timer to decide when male looks for a mate
	if mating_stats.gender == 0: 
		# the higher the sex drive the less wait time and vice versa
		mate_timer.wait_time = clampi(roundi(514200.0 / pow(mating_stats.sex_drive + 100, 1.71)) + Global.rng.randf_range(-10, 10), 0, 999999)
		mate_timer.autostart = true
		mate_timer.timeout.connect(find_mate)
		add_child(mate_timer)

func begin_pregnacy(child : Node2D):
	# If male then return because male can't give birth; idiot!
	if mating_stats.gender == 0: return
	
	# wait until gestation period has ended
	await get_tree().create_timer(mating_stats.gestation_period).timeout
	
	# add slime child to scene
	child.global_position = owner.global_position
	get_tree().current_scene.add_child(child)
	
	# set female slime fertilty to true so it can reproduce once again
	mating_stats.is_fertile = true

func find_mate():
	if !mating_stats.is_fertile: return
	if should_seek_partner(): action_component.queue_up_action("Mate", 0.3)
	
	mate_timer.wait_time = clampi(roundi(514200.0 / pow(mating_stats.sex_drive + 100, 1.71)), 0, 99999) + Global.rng.randf_range(0, 10)

func should_seek_partner() -> bool:
	# If recently ate, recently drank, is fertile, and is full grown then male slime can look for a mate
	return mating_stats.is_fertile \
	and hunger_component.recently_ate == true \
	and thrist_component.recently_dranked == true \
	and growth_component.growth == 1.0 \
	and mating_stats.is_fertile == true
