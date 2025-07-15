extends Resource
class_name MatingStats

enum GENDERS {MALE, FEMALE}

@export var reproduction_cooldown : float

#General
@export var gender = GENDERS.MALE
@export_range(0, 500) var attractiveness : float = 100.0 # 100 is default value

#Male
@export var sex_drive : float = 100 # 100 is default value

#Female
@export var offspring_count : int = 1
@export_range(0.0, 240.0) var gestation_period : float = 120
