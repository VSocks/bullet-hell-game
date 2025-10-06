extends Node2D
class_name SingleShotAttack

var fire_rate: float = 1.5
var can_shoot: bool = true

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	if can_shoot:
		shoot()

func shoot():
	var bullet = BulletPool.get_bullet("eb_diamond")
	bullet.initialize(global_position, Vector2.DOWN, 300, Vector2.DOWN.angle())
