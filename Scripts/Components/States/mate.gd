extends State
class_name mate

@export_category("Refrence")
@export var mating_component : mating_component

@export_category("Scenes")
@export var base_slime_scene = preload("res://Scenes/Characters/Slimes/slime.tscn")

var partner : Node2D = null

func enter():
	if !partner: await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander"); return
	if owner.stat_sheet.mating_stats.gender == 0: await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander"); return
	
	# Set female slime to infertile
	mating_component.mating_stats.is_fertile == false
	
	for i in mating_component.mating_stats.offspring_count:
		var slime_child = base_slime_scene.instantiate()
			# Create new StatSheet for the child
		var child_stat_sheet = StatSheet.new()
		
		# Average HealthStats
		var child_health_stats = HealthStats.new()
		child_health_stats.health = int((owner.stat_sheet.health_stats.health + partner.stat_sheet.health_stats.health) / 2)
		child_stat_sheet.health_stats = child_health_stats
		
		# Average MovementStats
		var child_move_stats = MovementStats.new()
		child_move_stats.speed = int((owner.stat_sheet.movement_stats.speed + partner.stat_sheet.movement_stats.speed) / 2)
		child_stat_sheet.movement_stats = child_move_stats
		
		# Average ActionStats
		var child_action_stats = ActionStats.new()
		child_action_stats.vision_range = (owner.stat_sheet.action_stats.vision_range + partner.stat_sheet.action_stats.vision_range) / 2.0
		child_action_stats.action_range = (owner.stat_sheet.action_stats.action_range + partner.stat_sheet.action_stats.action_range) / 2.0
		child_stat_sheet.action_stats = child_action_stats
		
		# Average MatingStats - here only some meaningful stats
		var child_mating_stats = MatingStats.new()
		child_mating_stats.attractiveness = (owner.stat_sheet.mating_stats.attractiveness + partner.stat_sheet.mating_stats.attractiveness) / 2.0
		child_mating_stats.sex_drive = (owner.stat_sheet.mating_stats.sex_drive + partner.stat_sheet.mating_stats.sex_drive) / 2.0
		# For gender, you might randomize or pick one parent’s gender
		if randi() % 2 == 0: child_mating_stats.gender = 0
		else: child_mating_stats.gender = 1
		child_stat_sheet.mating_stats = child_mating_stats
		
		# Average DietStats (hunger/thirst decay times can be averaged too)
		var child_diet_stats = DietStats.new()
		child_diet_stats.hunger = int((owner.stat_sheet.diet_stats.hunger + partner.stat_sheet.diet_stats.hunger) / 2)
		child_diet_stats.hunger_decay = (owner.stat_sheet.diet_stats.hunger_decay + partner.stat_sheet.diet_stats.hunger_decay) / 2.0
		child_diet_stats.thrist = int((owner.stat_sheet.diet_stats.thrist + partner.stat_sheet.diet_stats.thrist) / 2)
		child_diet_stats.thrist_decay = (owner.stat_sheet.diet_stats.thrist_decay + partner.stat_sheet.diet_stats.thrist_decay) / 2.0
		# For diet array, you might pick one parent’s diet or merge arrays intelligently
		if randi() % 2 == 0: child_diet_stats.diet = owner.stat_sheet.diet_stats.diet.duplicate()
		else: child_diet_stats.diet = partner.stat_sheet.diet_stats.diet.duplicate()
		child_stat_sheet.diet_stats = child_diet_stats
		
		# GrowthStats
		var child_growth_stats = GrowthStats.new()
		child_growth_stats.growth_speed = (owner.stat_sheet.growth_stats.growth_speed + partner.stat_sheet.growth_stats.growth_speed) / 2.0
		# change child's inital growth based on female's gestation period
		child_growth_stats.inital_growth = owner.stat_sheet.mating_stats.gestation_period * (50/120)
		child_stat_sheet.growth_stats = child_growth_stats
		
		# Assign child's stat sheet
		slime_child.stat_sheet = child_stat_sheet
		
		# Create Child
		owner.get_node("MatingComponent").begin_pregnacy(slime_child)
	
	await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander")

func exit(): Exited.emit(); partner = null
