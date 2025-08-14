extends Area2D

const damage : int = 1

var speed : int = 1
var direction = Vector2.DOWN

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(hitbox):
	if hitbox is Player:
		hitbox.take_damage(damage)
		queue_free()

func _on_screen_exited():
	queue_free()
