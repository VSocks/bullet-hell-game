extends Node2D

const SWEEP_ANGLE : float = 140.0
const ANGLE_STEP : float = 6.5
const SHOT_INTERVAL : float = 0.05

var is_attacking : bool = false
var current_angle : float = 0.0
var sweep_direction : int = 1
var angle : float = 0.0

@onready var shot_timer = $ShotTimer
@onready var movement_timer = $MovementTimer
@onready var boss = get_parent().get_parent()


func start_attack():
	is_attacking = true
	current_angle = deg_to_rad(SWEEP_ANGLE / 2)
	sweep_direction = 1
	shot_timer.wait_time = SHOT_INTERVAL
	movement_timer.wait_time = 1
	shot_timer.start()
	movement_timer.start()
	#print("Sweeping laser attack started!")


func stop_attack():
	is_attacking = false
	shot_timer.stop()
	#print("Sweeping laser attack stopped!")


func shoot():
	if not is_attacking:
		return
	
	shoot_at_angle()
	current_angle += ANGLE_STEP * sweep_direction
	
	if sweep_direction == 1 and current_angle >= SWEEP_ANGLE / 2:
		sweep_direction *= -1
	elif sweep_direction == -1 and current_angle <= -SWEEP_ANGLE / 2:
		sweep_direction *= -1


func shoot_at_angle():
	var orientation = 1
	var offset = [0, 0, 30, -30, 60, -60, 90, -90]
	
	for i in range(8):
		var bullet
		var bullet_speed
		var direction = Vector2.DOWN.rotated(deg_to_rad((current_angle * orientation) + offset[i]))
		if i > 5:
			bullet_speed = 200
			bullet = BulletPool.get_bullet("eb_missile")
			bullet.define_tragectory("curved")
			bullet.define_curve(0.5 * orientation)
		else:
			bullet_speed = 250
			bullet = BulletPool.get_bullet("eb_laser")
		bullet.initialize(global_position, direction, bullet_speed, direction.angle())
		orientation *= -1


func _on_shot_timer_timeout():
	shoot()
	shot_timer.start()


func _on_movement_timer_timeout():
	boss.move_to_random_position()
