extends Node2D

const BULLET_COUNT : int = 7
const FIRE_RATE : float = 0.075
const SPEED : int = 800

var spread_angle : float
var angle_step : float 

@onready var fire_rate_timer = $FireRateTimer


func start_attack():
	spread_angle = deg_to_rad(3 * BULLET_COUNT)
	angle_step = spread_angle / (BULLET_COUNT - 1)
	shoot()
	fire_rate_timer.wait_time = FIRE_RATE
	fire_rate_timer.start()
	#print("player attack started!")


func stop_attack():
	fire_rate_timer.stop()
	#print("player attack over!")


func shoot():
	var attack_rotation = get_parent().rotation
	var start_angle = (-spread_angle / 2) + attack_rotation
	for i in range(BULLET_COUNT):
		var current_angle = start_angle + (angle_step * i)
		var direction = Vector2(0, -1).rotated(current_angle)
		var bullet = BulletPool.get_bullet("pb_laser")
		bullet.initialize(global_position, direction, SPEED, direction.angle())


func _on_fire_rate_timer_timeout():
	shoot()
