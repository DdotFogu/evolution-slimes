extends CanvasLayer

var pop_count : int = 0
var can_pause : bool = false

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Master")

@onready var ui_player: AnimationPlayer = $AnimationPlayer

# show correct values on labels and set to size for later use
func _process(delta: float) -> void:
	if visible:
		#slime settings
		%PopCount.text = str(%Pop.value)
		
		#world settings
		%XCount.text = "X : " + str(%X.value)
		%YCount.text = "Y : " + str(%Y.value)
		
		%FoodCount.text = str(%Food.value)
		if %X.value > %Y.value: %Food.max_value = roundi(%X.value / 10 * 5)
		elif %X.value < %Y.value: %Food.max_value = roundi(%Y.value / 10 * 5)
		else: %Food.max_value = roundi(%X.value / 10 * 5)
		
		%WaterCount.text = str(%Water.value)
		if %X.value > %Y.value: %Water.max_value = roundi(%X.value / 20)
		elif %X.value < %Y.value: %Water.max_value = roundi(%Y.value / 20)
		else: %Water.max_value = roundi(%X.value / 20)
		
		#species stats
		%HPCount.text = str(%HP.value)
		%SpeedCount.text = str(%Speed.value)
		%VisionCount.text = str(%Vision.value)
		%ActionCount.text = str(%Action.value)
		%HDecayCount.text = str(%HungerDecay.value)
		%TDecayCount.text = str(%ThirstDecay.value)
		%DriveCount.text = str(%SexDrive.value)
		%GestationCount.text = str(%Gestation.value) + " secs"
		%VarationCount.text = str(%Varation.value) + "%"
		
		var base_color : Color = %ColorPickerButton.color
		%Slime.material.set_shader_parameter("new_one", base_color)
		var light_color = base_color
		light_color = light_color.lightened(0.35) 
		%Slime.material.set_shader_parameter("new_two", light_color)
		var dark_color = base_color
		dark_color = dark_color.darkened(0.25)
		%Slime.material.set_shader_parameter("new_three", dark_color)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Reset"):
		if !can_pause: return
		
		if %"Paused Menu".visible == false:
			%Graphing.visible = false
			ui_player.play("pause")
			get_tree().paused = true
		else:
			%Graphing.visible = true
			ui_player.play("clear")
			get_tree().paused = false

func create() -> void:
	#create world map and allow cam movement
	var data := WorldData.new()
	data.inital_population = %Pop.value
	data.world_size = Vector2(%X.value, %Y.value)
	data.food_count = %Food.value
	data.water_count = %Water.value
	
	Global.current_camera.allow_movement = true
	ui_player.play("clear")
	
	await %MapManager.create_world(data)
	for i in range(data.inital_population):
		%MapManager.create_slime_pop(1, get_slime_data())
	
	%Graphing.clear_data()
	%Graphing.visible = true

func get_slime_data():
	#create species_data
	var species_data = StatSheet.new()
	
	# genetic varaiton
	var varaiton : float = %Varation.value / 10
	
	#Health Stats
	var species_health_stats = HealthStats.new()
	species_health_stats.health = %HP.value + (%HP.value * Global.rng.randf_range(0.0, varaiton))
	species_data.health_stats = species_health_stats
	
	#Movement Stats
	var species_movement_stats = MovementStats.new()
	species_movement_stats.speed = %Speed.value + (%Speed.value * Global.rng.randf_range(0.0, varaiton))
	species_data.movement_stats = species_movement_stats
	
	#Action Stats
	var species_action_stats = ActionStats.new()
	species_action_stats.vision_range = %Vision.value + (%Vision.value * Global.rng.randf_range(0.0, varaiton))
	species_action_stats.action_range = %Action.value + (%Action.value * Global.rng.randf_range(0.0, varaiton))
	species_data.action_stats = species_action_stats
	
	#Diet Stats
	var species_diet_stats = DietStats.new()
	if %Fruit.button_pressed: species_diet_stats.diet.append("Fruit")
	if %Meat.button_pressed: species_diet_stats.diet.append("Meat")
	species_diet_stats.hunger_decay = %HungerDecay.value + (%HungerDecay.value * Global.rng.randf_range(0.0, varaiton))
	species_diet_stats.thrist_decay = %ThirstDecay.value + (%ThirstDecay.value * Global.rng.randf_range(0.0, varaiton))
	species_data.diet_stats = species_diet_stats
	
	pop_count += 1
	
	#Mating Stats
	var species_mate_stats = MatingStats.new()
	species_mate_stats.sex_drive = %SexDrive.value + (%SexDrive.value * Global.rng.randf_range(0.0, varaiton))
	species_mate_stats.gestation_period = %Gestation.value + (%Gestation.value * Global.rng.randf_range(0.0, varaiton))
	species_mate_stats.gender = pop_count % 2
	species_data.mating_stats = species_mate_stats
	
	species_data.character_color = %ColorPickerButton.color
	
	return species_data

func reset_slime_sliders() -> void:
	%HP.value = 5
	%Speed.value = 250
	%Vision.value = 1500
	%Action.value = 200
	%Fruit.button_pressed = true
	%Meat.button_pressed = false
	%HungerDecay.value = 0.1
	%ThirstDecay.value = 0.1
	%SexDrive.value = 100
	%Gestation.value = 120
	%ColorPickerButton.color = Color.HOT_PINK

func randomize_slime_sliders():
	for control in %SettingsContainer.get_children():
		for child in control.get_children():
			if child is HSlider:
				child.value = Global.rng.randf_range(child.min_value, child.max_value)
	
	var random_color = Color(randf(), randf(), randf())
	%ColorPickerButton.color = random_color

func set_screen_mode(mode_value : int = 0):
	%FullScreen.button_pressed = false
	%Windowed.button_pressed = false
	%BorderLess.button_pressed = false
	
	match mode_value:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			%FullScreen.button_pressed = true
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			%Windowed.button_pressed = true
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			%BorderLess.button_pressed = true

func master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)

func music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(music_bus, true)
	else:
		AudioServer.set_bus_mute(music_bus, false)

func fps_toggle_pressed(toggled_on: bool) -> void:
	Info.get_node("FPS").visible = toggled_on

func on_menu_pressed() -> void:
	get_tree().paused = false
	%MapManager.destory_world()
	%Graphing.visible = false
	ui_player.play("main")

func exit_app() -> void: get_tree().quit()
