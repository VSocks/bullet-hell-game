extends Node2D
class_name DelayedDiagonalMovement

var speed: float = 100.0
var delay: float = 1.0
var timer: float = 0.0
var has_moved: bool = false
var diagonal_direction: Vector2

func _ready():
	# Randomly choose left or right diagonal
	if randf() > 0.5:
		diagonal_direction = Vector2(0.7, 0.7).normalized()  # Right-down
	else:
		diagonal_direction = Vector2(-0.7, 0.7).normalized() # Left-down

func _physics_process(delta):
	if not has_moved:
		timer += delta
		if timer >= delay:
			has_moved = true
	else:
		get_parent().position += diagonal_direction * speed * delta
	
	# Remove if off-screen
	if get_parent().position.y > get_viewport_rect().size.y + 50:
		get_parent().queue_free()
