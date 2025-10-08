extends Node2D

var shot_interval: float = 0.05
var cooldown: float = 0.2
var fan_angles: Array = [45, 67.5, 90, 112.5, 135]  # In degrees

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = cooldown
	timer.start()

func _on_timer_timeout():
	start_fan_sequence()

func start_fan_sequence():
	timer.stop()
	for i in range(fan_angles.size()):
		await get_tree().create_timer(shot_interval).timeout
		shoot_single(fan_angles[i])
	fan_angles.reverse()
	timer.start()

func shoot_single(angle_degrees: float):
	var angle = deg_to_rad(angle_degrees)
	var direction = Vector2(cos(angle), sin(angle))
	
	var bullet = BulletPool.get_bullet("eb_diamond")
	bullet.initialize(global_position, direction, 200, direction.angle())
