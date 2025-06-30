extends Resource
class_name StatSheet

@export_category("Stats")
@export var health : int = 5
@export var hunger : int = 5
@export var vision_range : float = 500.0
@export var action_range : float = 50.0

@export_category("Movement")
@export var speed : int = 200
@export var speed_cap : int = 1250
@export var friction : float = 0.01
@export var acceleration : float = 0.1
