extends Node2D

var descent_speed: float = 60.0
var spiral_speed: float = 3.0
var spiral_radius: float = 80.0
var radius_decay: float = 0.95  # Radius decreases over time
var time: float = 0.0
var start_position: Vector2

func _ready():
	start_position = get_parent().position

func _physics_process(delta):
	time += delta
	
	var current_radius = spiral_radius * pow(radius_decay, time)
	var angle = time * spiral_speed
	
	get_parent().position = start_position + Vector2(
		cos(angle) * current_radius,
		sin(angle) * current_radius * 0.7 + (descent_speed * time)  # Spiral + descent
	)
	
	if get_parent().position.y > get_viewport_rect().size.y + 50:
		get_parent().queue_free()
