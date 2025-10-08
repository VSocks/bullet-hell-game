extends Node2D

var fire_rate: float = 1.0
var bullet_count: int = 36

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	shoot_circle()

func shoot_circle():
	for i in range(bullet_count):
		var angle = (TAU / bullet_count) * i
		var direction = Vector2(cos(angle), sin(angle))
		
		var bullet = BulletPool.get_bullet("eb_square")
		bullet.initialize(global_position, direction, 200, direction.angle())
