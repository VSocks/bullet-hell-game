extends Node2D

var fire_rate: float = 0.1

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	shoot_cross()

func shoot_cross():
	# Four cardinal directions
	var directions = [
		Vector2.UP,
		Vector2.DOWN, 
		Vector2.LEFT,
		Vector2.RIGHT
	]
	
	for direction in directions:
		var bullet = BulletPool.get_bullet("eb_square")
		bullet.initialize(global_position, direction, 200, direction.angle())
