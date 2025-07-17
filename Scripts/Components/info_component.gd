@icon("res://Assets/IconGodotNode/node/icon_beetle.png")
extends TextureButton
class_name InfoComponent

@onready var stat_sheet = $"..".stat_sheet

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	
	Global.grapher.reserved_data["POP"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : Global.population_count
	})
	Global.grapher.reserved_data["HP"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : stat_sheet.health_stats.health
	})
	Global.grapher.reserved_data["SPEED"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : stat_sheet.movement_stats.speed
	})
	Global.grapher.reserved_data["VISION"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : stat_sheet.action_stats.vision_range
	})
	Global.grapher.reserved_data["ACTION"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : stat_sheet.action_stats.action_range
	})
	Global.grapher.reserved_data["DRIVE"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : stat_sheet.mating_stats.sex_drive
	})
	Global.grapher.reserved_data["GESTATION"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : stat_sheet.mating_stats.gestation_period
	})
	Global.grapher.reserved_data["ATTRACTIVENESS"].append({
		"X" : Time.get_ticks_msec() / 1000,
		"Y" : stat_sheet.mating_stats.attractiveness
	})

func _on_pressed() -> void:
	Info.show_information(owner)
