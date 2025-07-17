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
	# If female then set to idle and await
	if owner.stat_sheet.mating_stats.gender == 1:
		# If male partner is no long attempting mate, then clear action
		while true:
			await get_tree().create_timer(1).timeout
			if !get_state("mate").partner: break
			if get_state("mate").partner.get_node("ActionComponet").current_action.size() == 0: break
			if get_state("mate").partner.get_node("ActionComponet").current_action["Action"] != "Mate":
				break
			
			print("Male lost intrest; stoping mate action")
			if current_action.size() == 0: return
			if current_action["Action"] == "Mate":
				await get_tree().create_timer(0.1).timeout; clear_curr_action(); get_state("wander").change_to_state(); return
	
	var candidates := []
	# Gather all slimes within range
	if !vision_component.sort_objects(["Slime"]).has("Slime"): await get_tree().create_timer(0.1).timeout; clear_curr_action(); get_state("wander").change_to_state(); return
	for slime in vision_component.sort_objects(["Slime"])["Slime"]: if slime != owner: candidates.append(slime)
	
	var attractiveness_dict := []
	var attractiveness_total : float = 0.0
	
	# Filter out slimes and collect attractiveness data
	for candidate : CharacterBody2D in candidates.duplicate():
		if !candidate: continue
		# if male then filter out
		if candidate.stat_sheet.mating_stats.gender == 0: continue
		# if slime is infetile then filter out
		if candidate.get_node("MatingComponent").is_fertile == false: continue
		# if slime isnt fully grown then filter out
		if candidate.get_node("GrowthComponent").growth != 1.0: continue
		
		var attr = candidate.stat_sheet.mating_stats.attractiveness
		attractiveness_total += attr
		if !candidate: continue
		attractiveness_dict.append({
			"Slime": candidate,
			"Attractiveness": attr
		})
	
	if attractiveness_dict.size() == 0: await get_tree().create_timer(0.1).timeout; clear_curr_action(); get_state("wander").change_to_state(); return
	
	# Normalize to percentage
	if attractiveness_total > 0:
		for dict in attractiveness_dict:
			dict["Attractiveness"] = (dict["Attractiveness"] / attractiveness_total) * 100
	
	# Choose a mating partner with a weighted algorithm 
	var roll := Global.rng.randf() * 100.0
	var current := 0.0
	var chosen_slime : Node2D
	for dict in attractiveness_dict:
		current += dict["Attractiveness"]
		if roll <= current: chosen_slime = dict["Slime"]; break
	
	# Male slime goto female slime and then try for mate
	chosen_slime.get_node("ActionComponet").queue_up_action("Mate", 0.3)
	goto(chosen_slime.global_position); await get_state("goto").Exited
	
	if chosen_slime:
		get_state("mate").partner = chosen_slime
		chosen_slime.get_node("ActionComponet").get_state("mate").partner = owner
		
		chosen_slime.get_node("ActionComponet").get_state("mate").change_to_state()
	
	get_state("mate").change_to_state()

func eat_action():
	var closest_source = vision_component.closest_source("Fruit")
	
	# If there's no valid source, switch to wander and wait until a valid one appears
	if closest_source == null or closest_source.edible == false:
		get_state("explore").change_to_state()
		
		while true:
			await get_tree().create_timer(1).timeout
			closest_source = vision_component.closest_source("Fruit")
			
			if closest_source != null and closest_source.edible:
				break
	
	# If the fruit is not edible anymore, restart action
	if closest_source.edible == false:
		eat_action()
		return
	
	# Go to the fruit
	goto(closest_source.global_position)
	await get_state("goto").Exited
	
	# Re-check in case something changed
	closest_source = vision_component.closest_source("Fruit")
	if closest_source == null or closest_source.edible == false:
		eat_action()
		return
	
	get_state("eat").change_to_state()

func drink_action():
	var closest_source = vision_component.closest_source("Water")
	
	# If there's no valid source, switch to wander and wait until a valid one appears
	if closest_source == null:
		get_state("explore").change_to_state()
		
		while true:
			await get_tree().create_timer(1).timeout
			closest_source = vision_component.closest_source("Water")
			
			if closest_source != null:
				break
	
	goto(closest_source.global_position, closest_source.get_node("CollisionComponent").shape.size.x - 20); await get_state("goto").Exited
	
	get_state("drink").change_to_state();
