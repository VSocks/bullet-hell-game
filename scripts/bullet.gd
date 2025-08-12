extends Area2D
var speed = 500
const damage = 1

func _process(delta):
	position += transform.x * position * delta

func _on_screen_exited():
	print("bullet deleted")
	queue_free()
