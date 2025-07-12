@icon("res://Assets/IconGodotNode/color/icon_heart.png")
extends Node
class_name health_component

signal took_damage
signal death

@onready var health : int = owner.stat_sheet.health_stats.health

func take_damage(amount : int, hideDamage : bool = false):
	health = clampi(health - amount, 0, owner.stat_sheet.health_stats.health)
	
	took_damage.emit()
	
	if health <= 0:
		die()

func die():
	await get_tree().create_timer(0.1).timeout
	
	print("A SLIME HAS DIED")
	Global.slime_pop -= 1
	
	death.emit()
	owner.queue_free()
