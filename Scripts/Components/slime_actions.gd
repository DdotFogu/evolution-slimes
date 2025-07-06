extends action_component
class_name slime_action

signal action

func _process(delta: float) -> void: super(delta)

func match_action(action_to_match : Dictionary):
	action.emit()
	match action_to_match["Action"]:
		"Eat": eat_action(); return
		"Drink": drink_action(); return
		"Mate": mate_action(); return
	print(action_to_match["Action"] + " DOES NOT MATCH")
	clear_curr_action()

func mate_action():
	var candidates := []
	for slime in vision_component.sort_objects(["Slime"])["Slime"]:
		candidates.append(slime)
	candidates.erase(owner)
	
	for slime : CharacterBody2D in candidates:
		if slime.stat_sheet.mating_stats.gender == 0: candidates.erase(slime)
	
	

func eat_action():
	var closest_source = vision_component.closest_source("Fruit"); if closest_source == null:
		explore_state.change_to_state(); 
		while vision_component.closest_source("Fruit") == null: await get_tree().create_timer(1).timeout
		closest_source = vision_component.closest_source("Fruit")
	
	goto(closest_source.global_position); await goto_state.Exited
	
	eat_state.change_to_state();

func drink_action():
	var closest_source = vision_component.closest_source("Water"); if closest_source == null: 
		print("CANT DRINK")
		explore_state.change_to_state(); 
		while vision_component.closest_source("Water") == null: await get_tree().create_timer(1).timeout
		closest_source = vision_component.closest_source("Water")
	
	goto(closest_source.global_position, closest_source.get_node("CollisionComponent").shape.size.x); await goto_state.Exited
	
	drink_state.change_to_state();
