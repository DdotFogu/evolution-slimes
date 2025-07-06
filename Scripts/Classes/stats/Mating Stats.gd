extends Resource
class_name MatingStats

enum GENDERS {MALE, FEMALE}

@export var reproduction_cooldown : float

#General
@export var gender = GENDERS.MALE
@export var is_fertile : bool = true
@export var attractiveness : float = 100 # 100 is highest value

#Male
@export var sex_drive : float = 100 # 100 is default value

#Female
@export var offspring_count : int = 1
@export var gestation_period : float = 100
@export var is_pregnant : bool = false
