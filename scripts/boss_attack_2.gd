extends Node2D

const PRIMARY_BULLET_COUNT : int = 6
const MAX_BURST_SHOTS : int = 10
const SHOT_INTERVAL : float = 0.07
const COOLDOWN : float = 0.5
const TOTAL_CYCLE_TIME : float = (MAX_BURST_SHOTS * SHOT_INTERVAL) + COOLDOWN + 0.05
const ANGLE_INCREMENT : float = 3

var burst_count : int = 0
var angle : float = 0.0
var is_attacking : bool = false

@onready var shot_timer_primary = $ShotTimer
@onready var cycle_timer = $CycleTimer


func start_attack():
	is_attacking = true
	start_cycle()


func stop_attack():
	is_attacking = false
	shot_timer_primary.stop()
	cycle_timer.stop()


func start_cycle():
	if is_attacking:
		burst_count = 0
		if angle > 360:
			angle = angle - 360
		shot_timer_primary.wait_time = SHOT_INTERVAL
		shot_timer_primary.start()
		shoot_primary()
		cycle_timer.wait_time = TOTAL_CYCLE_TIME
		cycle_timer.start()



func shoot_primary():
	for i in range(PRIMARY_BULLET_COUNT):
		var bullet_angle = (deg_to_rad(angle) + (TAU / PRIMARY_BULLET_COUNT) * i)
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet
		if burst_count == 0 or burst_count == MAX_BURST_SHOTS -1 or burst_count == MAX_BURST_SHOTS/2:
			bullet = BulletPool.get_bullet("eb_round_big")
		else:
			bullet = BulletPool.get_bullet("eb_round")
		bullet.initialize(global_position, direction, 350, direction.angle())
		bullet.define_tragectory("bounce")
		bullet.define_bounce(6, -250, 350)
	angle += ANGLE_INCREMENT
	burst_count += 1


func _on_shot_timer_timeout():
	if is_attacking and burst_count < MAX_BURST_SHOTS:
		shoot_primary()
		shot_timer_primary.start()


func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()
