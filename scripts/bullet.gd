extends Area2D

const damage : int = 1

var speed : int = 1
var direction = Vector2.DOWN

func _process(delta):
	position += direction * speed * delta

func _on_screen_exited():
	print("bullet deleted")
	queue_free()
