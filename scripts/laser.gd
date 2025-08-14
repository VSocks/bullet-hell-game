extends Area2D

const damage : int = 1

var speed : int = 1500

func _process(delta):
	position.y -= speed * delta

func _on_body_entered(hitbox):
	if hitbox is Boss:
		hitbox.take_damage(damage)
		queue_free()

func _on_screen_exited():
	queue_free()
