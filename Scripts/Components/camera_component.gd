@icon("res://Assets/IconGodotNode/node/icon_camera_grid.png")
extends Camera2D
class_name camera_component

# Camera Follow Vars
@export var target : Node2D
@export var allow_movement : bool = false

#Other
var isPressed := false

func _ready() -> void:
	if target: change_target(target)

func _process(delta: float) -> void:
	if target != null: 
		var target_position = target.global_position
		global_position = target_position

func _input(event: InputEvent) -> void:
	if !allow_movement: return
	
	if event is InputEventMouseMotion and isPressed:
		change_target(null)
		Info.close_information()
		
		global_position -= event.relative
	
	if event is InputEventMouseButton:
		isPressed = event.pressed
		
		var tween = create_tween()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			tween.tween_property(self, "zoom", zoom + Vector2(0.01,0.01), 0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			tween.tween_property(self, "zoom", zoom - Vector2(0.01,0.01), 0)
		
		zoom.clampf(0.01, 1.0)

func change_target(new_target : Node):
	target = null
	
	if new_target == null:
		return
	
	var pos_tween = get_tree().create_tween()
	
	await pos_tween.tween_property(self, "position", new_target.global_position, 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_QUINT).finished
	
	target = new_target
	
	if !target: return
	
	return true

func change_position(new_position : Vector2, speed : float = 1):
	var tween = get_tree().create_tween()
	await tween.tween_property(self, "position", new_position, speed).finished
	
	return

func change_zoom(new_zoom : Vector2, speed : float = 1):
	var tween = get_tree().create_tween()
	await tween.tween_property(self, "zoom", new_zoom, speed).finished
	
	return
