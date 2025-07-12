extends Resource
class_name DietStats

@export var diet : Array[String]

@export var hunger : int = 100
@export var hunger_decay : float = 0.01 # how much decays each 0.01
@export_range(0.0, 1.0) var hunger_threshold : float = 0.50 # percentage

@export var thrist : int = 100
@export var thrist_decay : float = 0.01 # how much decays each 0.01
@export_range(0.0, 1.0) var thrist_threshold : float = 0.50 # percentage
