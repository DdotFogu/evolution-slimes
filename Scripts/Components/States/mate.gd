extends State
class_name mate

@export_category("Refrence")
@export var mating_component : mating_component

@export_category("Scenes")
@export var base_child_scene = preload("res://Scenes/Characters/Slimes/Slime.tscn")

var partner : Node2D = null

func enter():
	if !partner: await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander"); return
	if owner.stat_sheet.mating_stats.gender == 0: await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander"); return
	
	for i in mating_component.mating_stats.offspring_count:
		
		var slime_child = mating_component.create_child(partner, base_child_scene)
		
		# Create Child
		mating_component.begin_pregnacy(slime_child)
		
		# Set female slime to infertile
		mating_component.is_fertile = false
	
	await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander")

func exit(): Exited.emit(); partner = null
