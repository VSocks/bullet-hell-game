extends Area2D

const damage : int = 1

var speed : int = 1500

func _process(delta):
	position.y -= speed * delta

func _on_area_entered(hitbox):
	if hitbox.has_method("take_damage"):
		hitbox.take_damage(damage)
		queue_free()

func _on_screen_exited():
	queue_free()
