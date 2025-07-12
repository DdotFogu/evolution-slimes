@icon("res://Assets/IconGodotNode/node/icon_camera_grid.png")
extends Camera2D
class_name camera_component

# Camera Follow Vars
@export var target : Node2D
@export var sens : float = 2
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
			tween.tween_property(self, "zoom", zoom + Vector2(0.1,0.1), 0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			tween.tween_property(self, "zoom", zoom - Vector2(0.1,0.1), 0)

func change_target(new_target : Node, speed : float = sens):
	target = new_target
	
	if !target: return
	
	var target_position = target.global_position
	
	
	return true
