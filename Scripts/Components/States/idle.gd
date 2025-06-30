extends State
class_name idle

func enter():
	Entered.emit()

func physics_update(_delta):
	if body == null: return
	body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.friction)
	body.move_and_slide()
