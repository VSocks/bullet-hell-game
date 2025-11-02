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
var bullet_orientation : int = 1
var angle : float = 0.0
var is_attacking : bool = false

@onready var shot_timer_primary = $ShotTimer
@onready var shot_timer_secondary = $ShotTimer2
@onready var cycle_timer = $CycleTimer
@onready var half_cycle_timer = $HalfCycleTimer
@onready var boss = get_parent().get_parent()



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
	for i in range(PRIMARY_BULLET_COUNT):
		var bullet_angle = ((deg_to_rad(angle) + (TAU / PRIMARY_BULLET_COUNT) * i)) * bullet_orientation
		var direction = (Vector2(cos(bullet_angle), sin(bullet_angle))) * bullet_orientation
		var bullet = BulletPool.get_bullet("eb_diamond")
		bullet.initialize(global_position, direction, 200, direction.angle())
	angle += ANGLE_INCREMENT
	burst_count += 1
	if burst_count >= MAX_BURST_SHOTS:
		bullet_orientation *= -1


func shoot_secondary():
	for i in range(SECONDARY_BULLET_COUNT):
		var bullet_angle = deg_to_rad(angle) + (TAU / SECONDARY_BULLET_COUNT) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet("eb_round_big")
		bullet.initialize(global_position, direction, 300, direction.angle())
	boss.move_to_random_position()


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
