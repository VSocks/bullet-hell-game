extends Node2D

var fire_rate: float = 0.6

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	shoot_grid()

func shoot_grid():
	# 3x3 grid pattern
	for x in range(-1, 2):  # -1, 0, 1
		for y in range(-1, 2):
			if x == 0 and y == 0:
				continue  # Skip center
				
			var direction = Vector2(x * 0.7, 1.0).normalized()  # Mostly downward
			
			var bullet = BulletPool.get_bullet("eb_laser")
			var position = get_parent().position + Vector2(x * 15, y * 15)
			bullet.initialize(position, direction, 200, direction.angle())
