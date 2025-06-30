@icon("res://Assets/IconGodotNode/color/icon_heart.png")
extends Node
class_name health_component

signal took_damage
signal death

@onready var health : int = owner.stat_sheet.health

func take_damage(amount : int, hideDamage : bool = false):
	health = clampi(health - amount, 0, owner.stat_sheet.health)
	
	took_damage.emit()
	
	if health <= 0:
		die()

func die():
	death.emit()
	owner.queue_free()
