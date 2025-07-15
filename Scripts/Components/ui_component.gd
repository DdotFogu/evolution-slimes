extends CanvasLayer

@onready var Info_animation: AnimationPlayer = $Information/AnimationPlayer

var info_visible : bool = false
var slime_stat_sheet : StatSheet
var last_selected_slime : Node2D = null

func _process(delta: float) -> void:
	%FPS.text = "FPS " + str(Engine.get_frames_per_second())
	
	if last_selected_slime:
		%HEALTH.text = "Health : " + str(last_selected_slime.get_node("HealthComponent").health)
		%DIET.text = "Diet : " + str(slime_stat_sheet.diet_stats.diet)
		%HUNGER.text = "Hunger : " + str(last_selected_slime.get_node("HungerComponent").remaining_hunger)
		%"HUNGER DECAY".text = "Hunger Decay : " + str(slime_stat_sheet.diet_stats.hunger_decay)
		%THIRST.text = "Thrist : " + str(last_selected_slime.get_node("ThristComponent").remaining_thrist)
		%"THIRST DECAY".text = "Thrist Decay : " + str(slime_stat_sheet.diet_stats.thrist_decay)
		%SPEED.text = "Speed : " + str(slime_stat_sheet.movement_stats.speed)
		%"VISION RANGE".text = "Vision Range : " + str(slime_stat_sheet.action_stats.vision_range)
		%"ACTION RANGE".text = "Action Range : " + str(slime_stat_sheet.action_stats.action_range)
		if slime_stat_sheet.mating_stats.gender == 0: %GENDER.text = "Gender : Male"
		elif slime_stat_sheet.mating_stats.gender == 1: %GENDER.text = "Gender : Female"
		%ATTRACTIVENESS.text = "Attractiveness : " + str(slime_stat_sheet.mating_stats.attractiveness)
		%"SEX DRIVE".text = "Sex Drive : " + str(slime_stat_sheet.mating_stats.sex_drive)
		if slime_stat_sheet.mating_stats.gender == 1: %"GESTATION PERIOD".text = "Gestation : " + str(slime_stat_sheet.mating_stats.gestation_period) + " secs"
		
		%"CURRENT ACTION".text = "Current Action" + "\n" + str(last_selected_slime.get_node("ActionComponet").current_action) + "\n"
		%STATE.text = "Active State" + "\n" + str(last_selected_slime.get_node("State Machine").current_state.name) + "\n" 
		%"QUEUED ACTIONS".text = "Queued Actions" + "\n" + str(last_selected_slime.get_node("ActionComponet").queued_actions) + "\n"

func show_information(selected_slime : Node2D):
	if selected_slime == last_selected_slime:
		close_information()
		return
	
	last_selected_slime = selected_slime
	info_visible = true
	Info_animation.play("Show")
	
	slime_stat_sheet = selected_slime.stat_sheet
	
	Global.current_camera.change_target(selected_slime)

func close_information():
	Info_animation.play("Close")
	info_visible = false
	last_selected_slime = null

func _on_stats_button_pressed() -> void: Info_animation.play("show_stats")

func _on_back_button_pressed() -> void: Info_animation.play("show_main")

func _on_action_button_pressed() -> void: Info_animation.play("show_action")
