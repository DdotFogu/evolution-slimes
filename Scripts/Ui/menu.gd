extends CanvasLayer

@onready var ui_player: AnimationPlayer = $AnimationPlayer

var size := Vector2i(10, 10)
var population : int = 2

# show correct values on labels and set to size for later use
func _on_x_value_changed(value: float) -> void:
	%XCount.text = str(value)
	size.x = value

func _on_y_value_changed(value: float) -> void:
	%YCount.text = str(value)
	size.y = value

func _on_pop_value_changed(value: float) -> void:
	%PopCount.text = str(value)
	population = value

func create() -> void:
	#create world map and allow cam movement
	%MapManager.create_world(size, population)
	Global.current_camera.allow_movement = true
	ui_player.play("clear")
