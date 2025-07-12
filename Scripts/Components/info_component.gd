@icon("res://Assets/IconGodotNode/node/icon_beetle.png")
extends TextureButton
class_name InfoComponent

func _on_pressed() -> void: Info.show_information(owner)
