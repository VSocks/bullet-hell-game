extends CharacterBody2D
class_name Laser

var damage : int = 1
var speed : int = 1500

func _physics_process(delta):
	var motion = Vector2.UP * speed * delta
	var collision = move_and_collide(motion)
	if collision:
		var hitbox = collision.get_collider()
		if hitbox is Boss:
			hitbox.take_damage(damage)
		queue_free()

func _on_screen_exited():
	queue_free()
