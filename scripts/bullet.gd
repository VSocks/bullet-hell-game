extends CharacterBody2D
class_name Bullet

var speed : int = 1
var direction = Vector2.DOWN

func _physics_process(delta):
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)
	if collision:
		var hitbox = collision.get_collider()
		if hitbox is Player:
			hitbox.take_damage()
		queue_free()

func _on_screen_exited():
	queue_free()
