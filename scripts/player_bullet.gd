extends Area2D
class_name Laser

var damage : int = 1
var speed : int = 1000

func _physics_process(delta):
	position += Vector2.UP * speed * delta

func _on_body_entered(hitbox):
	if hitbox is Boss:
		hitbox.take_damage(damage)
	queue_free()

func _on_screen_exited():
	queue_free()
