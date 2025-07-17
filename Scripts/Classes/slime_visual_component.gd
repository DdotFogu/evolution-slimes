extends visual_componet

func _ready() -> void:
	super()
	
	var base_color : Color = stat_sheet.character_color
	%Body.material.set_shader_parameter("new_one", base_color)
	var light_color = base_color
	light_color = light_color.lightened(0.35) 
	%Body.material.set_shader_parameter("new_two", light_color)
	var dark_color = base_color
	dark_color = dark_color.darkened(0.25)
	%Body.material.set_shader_parameter("new_three", dark_color)
