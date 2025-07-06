@icon("res://Assets/IconGodotNode/node/icon_camera_grid.png")
extends Camera2D
class_name camera_component

# Camera Follow Vars
@export var target : Node2D
@export var sens : float = 2

#Other
var isPressed := false

func _ready() -> void:
	if target: change_target(target)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and isPressed:
		global_position -= event.relative
	
	if event is InputEventMouseButton:
		isPressed = event.pressed
		
		var tween = create_tween()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			tween.tween_property(self, "zoom", zoom + Vector2(0.1,0.1), 0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			tween.tween_property(self, "zoom", zoom - Vector2(0.1,0.1), 0)

func change_target(new_target : Node, speed : float = sens, do_pause : bool = false):
	target = new_target
	
	if !target: return
	
	var target_position = target.global_position
	
	
	if do_pause: get_tree().paused = true
	var pos_tween = create_tween()
	await pos_tween.tween_property(self, "global_position", target_position, speed).finished
	if do_pause: get_tree().paused = false
	
	return true
