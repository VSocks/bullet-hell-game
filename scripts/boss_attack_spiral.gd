extends Node2D

const BULLET_COUNT : int = 36
const MAX_BURST_SHOTS : int = 12
const SHOT_INTERVAL : float = 0.075
const COOLDOWN : float = 1.5
const TOTAL_CYCLE_TIME : float = (MAX_BURST_SHOTS * SHOT_INTERVAL) + COOLDOWN + 0.1
const ANGLE_INCREMENT : float = 30

var burst_count : int = 0
var bullet_index : int = 0
var bullet_speed : int = 150
var angle : float = 0.0
var is_attacking : bool = false


@onready var shot_timer = $ShotTimer
@onready var cycle_timer = $CycleTimer


func start_attack():
	is_attacking = true
	start_cycle()
	#print("Spiral attack started!")


func stop_attack():
	is_attacking = false
	shot_timer.stop()
	cycle_timer.stop()
	#print("Spiral attack stopped!")	


func start_cycle():
	if is_attacking:
		burst_count = 0
		angle = 0
		shot_timer.wait_time = SHOT_INTERVAL
		shot_timer.start()
		shoot()
		cycle_timer.wait_time = TOTAL_CYCLE_TIME
		cycle_timer.start()


func shoot():
	var bullet_order = ["eb_diamond", "eb_square", "eb_round", "eb_round_big"]
	for i in range(BULLET_COUNT):
		var bullet_angle = angle + (TAU / BULLET_COUNT) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet(bullet_order[bullet_index])
		bullet.initialize(global_position, direction, bullet_speed, direction.angle())
		
	if bullet_index >= 3:
		bullet_index = 0
		bullet_speed = 150
	else:
		bullet_index += 1
		bullet_speed -= 20
	angle += ANGLE_INCREMENT
	burst_count += 1


func _on_shot_timer_timeout():
	if is_attacking and burst_count < MAX_BURST_SHOTS:
		shoot()
		shot_timer.start()


func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()
