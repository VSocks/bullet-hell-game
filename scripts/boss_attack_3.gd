extends Node2D

const SWEEP_ANGLE : float = 120.0
const ANGLE_STEP : float = 5.0
const LASER_SHOT_INTERVAL : float = 0.03
const SQUARE_SHOT_INTERVAL : float = 0.25
const EB_SQUARE_COUNT : int = 36
const ANGLE_INCREMENT : float = 5

var is_attacking : bool = false
var current_angle : float = 0.0
var sweep_direction : int = 1
var angle : float = 0.0

@onready var shot_timer_lasers = $ShotTimer
@onready var shot_timer_circle = $ShotTimer2


func start_attack():
	is_attacking = true
	current_angle = deg_to_rad(SWEEP_ANGLE / 2)
	sweep_direction = 1
	#shoot_lasers()
	shot_timer_lasers.wait_time = LASER_SHOT_INTERVAL
	shot_timer_circle.wait_time = SQUARE_SHOT_INTERVAL
	shot_timer_lasers.start()
	#shot_timer_circle.start()
	#print("Sweeping laser attack started!")


func stop_attack():
	is_attacking = false
	shot_timer_lasers.stop()
	#print("Sweeping laser attack stopped!")


func shoot_lasers():
	if not is_attacking:
		return
	
	shoot_at_angle(deg_to_rad(current_angle))
	current_angle += ANGLE_STEP * sweep_direction
	
	if sweep_direction == 1 and current_angle >= SWEEP_ANGLE / 2:
		print("condition 1")
		sweep_direction *= -1
		
	elif sweep_direction == -1 and current_angle <= -SWEEP_ANGLE / 2:
		print("condition 2")
		sweep_direction *= -1
	print(current_angle)
	print(sweep_direction)
	

func shoot_circle():
	for i in range(EB_SQUARE_COUNT):
		var bullet_angle = (deg_to_rad(angle) + (TAU / EB_SQUARE_COUNT) * i)
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet("eb_square")
		bullet.initialize(global_position, direction, 150, direction.angle())
	angle += ANGLE_INCREMENT
	if angle >= 360:
		angle -= 360


func shoot_at_angle(angle: float):
	var direction = Vector2.DOWN.rotated(deg_to_rad(current_angle))
	var direction2 = Vector2.DOWN.rotated(deg_to_rad(-current_angle))
	var direction3 = Vector2.DOWN.rotated(deg_to_rad(current_angle + 70))
	var direction4 = Vector2.DOWN.rotated(deg_to_rad(-current_angle - 70))
	var direction5 = Vector2.DOWN.rotated(deg_to_rad(current_angle + 90))
	var direction6 = Vector2.DOWN.rotated(deg_to_rad(-current_angle - 90))
	
	var bullet = BulletPool.get_bullet("eb_laser")
	var bullet2 = BulletPool.get_bullet("eb_laser")
	var bullet3 = BulletPool.get_bullet("eb_laser")
	var bullet4 = BulletPool.get_bullet("eb_laser")
	var bullet5 = BulletPool.get_bullet("eb_missile")
	var bullet6 = BulletPool.get_bullet("eb_missile")
	bullet.initialize(global_position, direction, 350, direction.angle())
	bullet2.initialize(global_position, direction2, 350, direction2.angle())
	bullet3.initialize(global_position, direction3, 350, direction3.angle())
	bullet4.initialize(global_position, direction4, 350, direction4.angle())
	bullet5.initialize(global_position, direction5, 250, direction5.angle())
	bullet6.initialize(global_position, direction6, 250, direction6.angle())
	bullet5.define_tragectory("curved")
	bullet6.define_tragectory("curved")
	bullet5.define_curve(0.3)
	bullet6.define_curve(-0.5)


func _on_shot_timer_timeout():
	shoot_lasers()
	shot_timer_lasers.start()
