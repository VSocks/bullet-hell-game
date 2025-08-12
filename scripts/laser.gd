extends Area2D
var speed = 1500

func _process(delta):
	position.y -= speed * delta

func _on_screen_exited():
	print("laser deleted")
	queue_free()
