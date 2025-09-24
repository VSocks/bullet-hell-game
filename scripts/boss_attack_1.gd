extends Node2D

const PRIMARY_BULLET_COUNT : int = 12
const SECONDARY_BULLET_COUNT : int = 36
const MAX_BURST_SHOTS : int = 8
const SHOT_INTERVAL : float = 0.05
const COOLDOWN : float = 0.25
const HALF_CYCLE_TIME : float = (MAX_BURST_SHOTS * SHOT_INTERVAL)
const TOTAL_CYCLE_TIME : float = (MAX_BURST_SHOTS * SHOT_INTERVAL) + COOLDOWN + 0.05
const ANGLE_INCREMENT : float = 5

var burst_count : int = 0
#var bullet_index : int = 0
var bullet_speed : int = 150
var bullet_orientation : int = 1
var angle : float = 0.0
var is_attacking : bool = false


@onready var shot_timer_primary = $ShotTimer
@onready var shot_timer_secondary = $ShotTimer2
@onready var cycle_timer = $CycleTimer
@onready var half_cycle_timer = $HalfCycleTimer


func start_attack():
	is_attacking = true
	start_cycle()


func stop_attack():
	is_attacking = false
	shot_timer_primary.stop()
	shot_timer_secondary.stop()
	cycle_timer.stop()


func start_cycle():
	if is_attacking:
		burst_count = 0
		angle = 0
		shot_timer_primary.wait_time = SHOT_INTERVAL
		shot_timer_primary.start()
		shoot_primary()
		cycle_timer.wait_time = TOTAL_CYCLE_TIME
		cycle_timer.start()
		half_cycle_timer.wait_time = HALF_CYCLE_TIME
		half_cycle_timer.start()


func shoot_primary():
	#var bullet_order = ["eb_diamond", "eb_square", "eb_round"]
	for i in range(PRIMARY_BULLET_COUNT):
		var bullet_angle = ((deg_to_rad(angle) + (TAU / PRIMARY_BULLET_COUNT) * i)) * bullet_orientation
		var direction = (Vector2(cos(bullet_angle), sin(bullet_angle))) * bullet_orientation
		var bullet = BulletPool.get_bullet("eb_diamond")
		bullet.initialize(global_position, direction, bullet_speed, direction.angle())
		#bullet.scale_bullet(1, 0.25)
		#bullet.define_tragectory("straight")
		#bullet.define_curve(0.4 * bullet_orientation)
		bullet.speed = 200
		#bullet.define_bounce(6, -150, 350)
		#var bullet_angle2 = -(deg_to_rad(angle) + (TAU / BULLET_COUNT) * i)
		#var direction2 = -(Vector2(cos(bullet_angle2), sin(bullet_angle2)))
		#var bullet2 = BulletPool.get_bullet(bullet_order[bullet_index])
		#bullet2.initialize(global_position, direction2, bullet_speed, direction2.angle())
		#bullet.scale_bullet(1, 0.25)
		#bullet2.define_tragectory("curved")
		#bullet2.define_curve(0.3)

		
	#if bullet_index >= 2:
	#	bullet_index = 0
		#bullet_speed = 150
	#else:
	#	bullet_index += 1
		#bullet_speed -= 20
	angle += ANGLE_INCREMENT
	burst_count += 1
	if burst_count >= MAX_BURST_SHOTS:
		bullet_orientation *= -1


func shoot_secondary():
	for i in range(SECONDARY_BULLET_COUNT):
		var bullet_angle = deg_to_rad(angle) + (TAU / SECONDARY_BULLET_COUNT) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet("eb_round_big")
		bullet.initialize(global_position, direction, bullet_speed, direction.angle())
		bullet.speed = 300


func _on_shot_timer_timeout():
	if is_attacking and burst_count < MAX_BURST_SHOTS:
		shoot_primary()
		shot_timer_primary.start()


func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()


func _on_shot_timer_2_timeout():
	shoot_secondary()
	shot_timer_secondary.stop()


func _on_half_cycle_timer_timeout():
	shot_timer_secondary.wait_time = 0.4
	shot_timer_secondary.start()
