extends Node2D

const BULLET_COUNT : int = 5
const FIRE_RATE : float = 0.1
const SPEED : int = 800

var bullet_spacing : int = 10

@onready var fire_rate_timer = $FireRateTimer


func start_attack():
	shoot()
	fire_rate_timer.wait_time = FIRE_RATE
	fire_rate_timer.start()
	#print("player attack started!")


func stop_attack():
	fire_rate_timer.stop()
	#print("player attack over!")


func shoot():
	var attack_rotation = get_parent().rotation /3
	for i in range(BULLET_COUNT):
		var offset = Vector2(-((BULLET_COUNT * bullet_spacing)/2) + (bullet_spacing * (i + 1)), 0).rotated(attack_rotation)
		var direction = Vector2.UP.rotated(attack_rotation)
		var bullet = BulletPool.get_bullet("pb_explosive")
		bullet.initialize(global_position + offset, direction, SPEED, direction.angle())


func _on_fire_rate_timer_timeout():
	shoot()
