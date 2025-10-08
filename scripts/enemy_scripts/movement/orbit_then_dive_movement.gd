extends Node2D

var orbit_speed: float = 2.0
var dive_speed: float = 180.0
var orbit_radius: float = 60.0
var orbit_time: float = 3.0
var time: float = 0.0
var state: String = "orbiting"
var orbit_center: Vector2

func _ready():
	orbit_center = get_parent().position
	state = "orbiting"

func _physics_process(delta):
	time += delta
	
	match state:
		"orbiting":
			var angle = time * orbit_speed
			get_parent().position = orbit_center + Vector2(
				cos(angle) * orbit_radius,
				sin(angle) * orbit_radius * 0.5  # Elliptical orbit
			)
			
			if time >= orbit_time:
				state = "diving"
				print("Orbit complete, starting dive!")
		
		"diving":
			get_parent().position.y += dive_speed * delta
	
	if get_parent().position.y > get_viewport_rect().size.y + 50:
		get_parent().queue_free()
