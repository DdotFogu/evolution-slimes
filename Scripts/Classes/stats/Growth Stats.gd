extends Resource
class_name GrowthStats

@export_range(0.0, 1.0) var inital_growth : float = 0.5
@export var growth_speed : float = 0.0001 # how much growth increases per 0.05 secs
