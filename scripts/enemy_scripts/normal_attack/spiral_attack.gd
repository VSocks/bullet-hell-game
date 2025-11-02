extends Node2D

var fire_rate: float = 0.1
var bullets_per_shot: int = 3
var spiral_angle: float = 0.0

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	shoot_double_spiral()

func shoot_double_spiral():
	for i in range(bullets_per_shot):
		var angle = spiral_angle + (PI * i)  # Opposite directions
		var direction = Vector2(cos(angle), sin(angle))
		
		var bullet = BulletPool.get_bullet("eb_diamond")
		bullet.initialize(global_position, direction, 200, direction.angle())
	
	spiral_angle += 0.3  # Rotate spiral
