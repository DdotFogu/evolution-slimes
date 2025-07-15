@icon("res://Assets/IconGodotNode/color/icon_heart.png")
extends Node
class_name health_component

signal took_damage
signal death

@export_category("Refrences")
@export var hunger_component : hunger_component

@onready var health : int = owner.stat_sheet.health_stats.health
@onready var regen_timer: Timer = $Timer

var recently_damage : bool = false

func take_damage(amount : int, hideDamage : bool = false):
	health = clampi(health - amount, 0, owner.stat_sheet.health_stats.health)
	
	took_damage.emit()
	regen_timer.start()
	
	if health <= 0:
		die()
	
	recently_damage = true
	await get_tree().create_timer(30).timeout; recently_damage = false

func regen():
	if health >= owner.stat_sheet.health_stats.health: 
		regen_timer.stop()
		return
	if !should_regen(): return
	
	take_damage(-1, true)

func die():
	await get_tree().create_timer(0.1).timeout
	
	death.emit()
	owner.queue_free()

func should_regen():
	return hunger_component.recently_ate == true \
	and recently_damage == false
