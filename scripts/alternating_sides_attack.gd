extends Node2D
class_name AlternatingSidesAttack

var fire_rate: float = 0.8
var current_side: int = 0  # 0 = left, 1 = right

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	shoot_alternating()

func shoot_alternating():
	var angles = []
	
	if current_side == 0:
		# Left side angles (pointing right/down-right)
		angles = [deg_to_rad(0), deg_to_rad(30), deg_to_rad(60)]
	else:
		# Right side angles (pointing left/down-left)  
		angles = [deg_to_rad(180), deg_to_rad(150), deg_to_rad(120)]
	
	for angle in angles:
		var direction = Vector2(cos(angle), sin(angle))
		var bullet = BulletPool.get_bullet("eb_diamond")
		bullet.initialize(global_position, direction, 200, direction.angle())
	
	current_side = 1 - current_side  # Switch sides
