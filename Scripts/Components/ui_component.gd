extends CanvasLayer
class_name ui_component

@onready var time_scale: HScrollBar = %TimeScale

func _process(delta: float) -> void:
	Engine.time_scale = clamp(time_scale.value, time_scale.min_value, time_scale.max_value)
