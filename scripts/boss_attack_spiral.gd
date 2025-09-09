extends Node2D

const BULLET_COUNT : int = 36
const MISSILE_COUNT : int = 72
const LASER_COUNT : int = 5
const MAX_BURST_SHOTS : int = 24
const SHOT_INTERVAL : float = 0.1
const COOLDOWN : float = 1
const HALF_CYCLE_TIME : float = (MAX_BURST_SHOTS * SHOT_INTERVAL)
const TOTAL_CYCLE_TIME : float = (MAX_BURST_SHOTS * SHOT_INTERVAL) + COOLDOWN + 0.1
const ANGLE_INCREMENT : float = 5

var burst_count : int = 0
var bullet_index : int = 0
var bullet_speed : int = 150
var angle : float = 0.0
var is_attacking : bool = false


@onready var shot_timer = $ShotTimer
@onready var cycle_timer = $CycleTimer
@onready var shot_timer_2 = $ShotTimer2
@onready var missile_timer = $MissileTimer
@onready var half_cycle_timer = $HalfCycleTimer


func start_attack():
	is_attacking = true
	start_cycle()
	#print("Spiral attack started!")


func stop_attack():
	is_attacking = false
	shot_timer.stop()
	shot_timer_2.stop()
	cycle_timer.stop()
	half_cycle_timer.stop()
	missile_timer.stop()
	#print("Spiral attack stopped!")	


func start_cycle():
	if is_attacking:
		burst_count = 0
		angle = 0
		shot_timer.wait_time = SHOT_INTERVAL
		shot_timer_2.wait_time = 0.05
		shot_timer.start()
		shot_timer_2.start()
		shoot()
		shoot_laser()
		cycle_timer.wait_time = TOTAL_CYCLE_TIME
		cycle_timer.start()
		half_cycle_timer.wait_time = HALF_CYCLE_TIME
		half_cycle_timer.start()


func shoot():
	var bullet_order = ["eb_diamond", "eb_square", "eb_round"]
	for i in range(BULLET_COUNT):
		var bullet_angle = deg_to_rad(angle) + (TAU / BULLET_COUNT) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet(bullet_order[bullet_index])
		bullet.initialize(global_position, direction, bullet_speed, direction.angle())
		bullet.scale_bullet(1, 0.25)
		bullet.define_tragectory("curved", 0.3)
		#var bullet_angle2 = -(deg_to_rad(angle) + (TAU / BULLET_COUNT) * i)
		#var direction2 = -(Vector2(cos(bullet_angle2), sin(bullet_angle2)))
		#var bullet2 = BulletPool.get_bullet(bullet_order[bullet_index])
		#bullet2.initialize(global_position, direction2, bullet_speed, direction2.angle())
		#bullet.scale_bullet(1, 0.25)
		#bullet2.define_tragectory("curved", 0.3)

		
	if bullet_index >= 2:
		bullet_index = 0
		#bullet_speed = 150
	else:
		bullet_index += 1
		#bullet_speed -= 20
	angle += ANGLE_INCREMENT
	burst_count += 1


func shoot_laser():
	var offset = -20
	for i in range(LASER_COUNT):
		var bullet = BulletPool.get_bullet("eb_laser")
		bullet.initialize(global_position + Vector2(offset, 0), Vector2.DOWN, bullet_speed * 3, bullet.direction.angle())
		bullet.scale_bullet(1, 0.2)
		offset += 10


func shoot_missiles():
	for i in range(MISSILE_COUNT):
		var bullet_angle = deg_to_rad(angle) + (TAU / MISSILE_COUNT) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet("eb_missile")
		bullet.initialize(global_position, direction, bullet_speed, direction.angle())
		bullet.scale_bullet(2, 0.1)
		bullet.speed = 400


func _on_shot_timer_timeout():
	if is_attacking and burst_count < MAX_BURST_SHOTS:
		shoot()
		shot_timer.start()


func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()


func _on_shot_timer_2_timeout():
	if is_attacking and burst_count < MAX_BURST_SHOTS:
		shoot_laser()
		shot_timer_2.start()


func _on_half_cycle_timer_timeout():
	missile_timer.wait_time = 0.4
	missile_timer.start()

func _on_missile_timer_timeout():
	shoot_missiles()
	missile_timer.stop()
