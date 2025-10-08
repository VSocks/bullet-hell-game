extends Node2D

var speed: float = 100.0

func _physics_process(delta):
	get_parent().position.y += speed * delta
	
	# Remove if off-screen
	if get_parent().position.y > get_viewport_rect().size.y + 50:
		get_parent().queue_free()
