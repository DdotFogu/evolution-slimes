@icon("res://Assets/IconGodotNode/node/icon_puzzle.png")
extends Node
class_name mating_component

@export_category("Refrences")
@export var hunger_component : hunger_component
@export var thrist_component : thrist_component
@export var growth_component : growth_component
@export var action_component : action_component

@export_category("Values")
@export var is_fertile : bool = true

@onready var mating_stats : MatingStats = owner.stat_sheet.mating_stats
@onready var mate_timer : Timer = Timer.new()

#func _process(delta: float) -> void:
	#if mating_stats.gender == 1:
		#print(is_fertile)

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
	Global.y_sort.get_node("Creatures").add_child(child)
	
	# set female slime fertilty to true so it can reproduce once again
	is_fertile = true

func find_mate():
	if should_seek_partner(): action_component.queue_up_action("Mate", 0.3)
	
	mate_timer.wait_time = clampi(roundi(514200.0 / pow(mating_stats.sex_drive + 100, 1.71)), 0, 99999) + Global.rng.randf_range(0, 10)

func should_seek_partner() -> bool:
	# If recently ate, recently drank, is fertile, and is full grown then male slime can look for a mate
	return is_fertile == true \
	and hunger_component.recently_ate == true \
	and thrist_component.recently_dranked == true \
	and growth_component.growth == 1.0

func avg_with_variance(a: float, b: float, variance: float = 0.1) -> float:
	var average = (a + b) / 2.0
	var offset = randf_range(-variance, variance) * average
	return average + offset

func create_child(partner: Node2D, base_child_scene: PackedScene):
	var new_child = base_child_scene.instantiate()
	
	# Determine which parent is female/male
	var female : Node2D
	var male : Node2D

	if owner.stat_sheet.mating_stats.gender == 0:
		female = owner
		male = partner
	else:
		female = partner
		male = owner
	
	# Create new StatSheet
	var child_stat_sheet = StatSheet.new()
	
	# HealthStats
	var child_health_stats = HealthStats.new()
	child_health_stats.health = round(avg_with_variance(owner.stat_sheet.health_stats.health, partner.stat_sheet.health_stats.health))
	child_stat_sheet.health_stats = child_health_stats
	
	# MovementStats
	var child_move_stats = MovementStats.new()
	child_move_stats.speed = round(avg_with_variance(owner.stat_sheet.movement_stats.speed, partner.stat_sheet.movement_stats.speed))
	child_stat_sheet.movement_stats = child_move_stats
	
	# ActionStats
	var child_action_stats = ActionStats.new()
	child_action_stats.vision_range = avg_with_variance(owner.stat_sheet.action_stats.vision_range, partner.stat_sheet.action_stats.vision_range)
	child_action_stats.action_range = avg_with_variance(owner.stat_sheet.action_stats.action_range, partner.stat_sheet.action_stats.action_range)
	child_stat_sheet.action_stats = child_action_stats
	
	# MatingStats
	var child_mating_stats = MatingStats.new()
	child_mating_stats.attractiveness = avg_with_variance(owner.stat_sheet.mating_stats.attractiveness, partner.stat_sheet.mating_stats.attractiveness)
	child_mating_stats.sex_drive = avg_with_variance(owner.stat_sheet.mating_stats.sex_drive, partner.stat_sheet.mating_stats.sex_drive)
	child_mating_stats.gender = randi() % 2
	child_stat_sheet.mating_stats = child_mating_stats
	
	# DietStats
	var child_diet_stats = DietStats.new()
	child_diet_stats.hunger = round(avg_with_variance(owner.stat_sheet.diet_stats.hunger, partner.stat_sheet.diet_stats.hunger))
	child_diet_stats.hunger_decay = avg_with_variance(owner.stat_sheet.diet_stats.hunger_decay, partner.stat_sheet.diet_stats.hunger_decay)
	child_diet_stats.thrist = round(avg_with_variance(owner.stat_sheet.diet_stats.thrist, partner.stat_sheet.diet_stats.thrist))
	child_diet_stats.thrist_decay = avg_with_variance(owner.stat_sheet.diet_stats.thrist_decay, partner.stat_sheet.diet_stats.thrist_decay)
	
	# Merge diets and remove duplicates
	var combined_diet = owner.stat_sheet.diet_stats.diet + partner.stat_sheet.diet_stats.diet
	for food in combined_diet:
		if not food in child_diet_stats.diet:
			child_diet_stats.diet.append(food)
	child_stat_sheet.diet_stats = child_diet_stats
	
	# GrowthStats
	var child_growth_stats = GrowthStats.new()
	child_growth_stats.growth_speed = avg_with_variance(owner.stat_sheet.growth_stats.growth_speed, partner.stat_sheet.growth_stats.growth_speed)
	
	const BASE_INITIAL_GROWTH_RATIO = 50.0 / 120.0
	child_growth_stats.inital_growth = female.stat_sheet.mating_stats.gestation_period * BASE_INITIAL_GROWTH_RATIO
	child_stat_sheet.growth_stats = child_growth_stats
	
	# Set Color
	var color_average = (owner.stat_sheet.character_color + partner.stat_sheet.character_color) / 2.0
	var variance : float = 0.1

	# Add a small random variance to each RGB channel individually
	var base_color : Color = Color(
		color_average.r + randf_range(-variance, variance),
		color_average.g + randf_range(-variance, variance),
		color_average.b + randf_range(-variance, variance),
		1.0  # fully opaque
	)

	# Clamp to valid color values just in case
	base_color.r = clamp(base_color.r, 0.0, 1.0)
	base_color.g = clamp(base_color.g, 0.0, 1.0)
	base_color.b = clamp(base_color.b, 0.0, 1.0)
	base_color.a = 1.0

	child_stat_sheet.character_color = base_color
	
	# Assign stat sheet
	new_child.stat_sheet = child_stat_sheet
	
	return new_child
