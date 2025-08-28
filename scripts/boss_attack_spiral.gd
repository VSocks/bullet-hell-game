extends Node2D

var is_attacking : bool = false
var burst_count : int = 0
var max_burst_shots : int = 12
var shot_interval : float = 0.075
var cooldown : float = 1.5
var total_cycle_time : float = (max_burst_shots * shot_interval) + cooldown + 0.1

var bullet_index : int = 0
var bullet_count : int = 36
var bullet_speed : int = 200
var angle : float = 0.0
var angle_increment : float = 30

@onready var shot_timer = $ShotTimer
@onready var cycle_timer = $CycleTimer


func _process(_delta):
	pass


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
		shot_timer.wait_time = shot_interval
		shot_timer.start()
		shoot()
		cycle_timer.wait_time = total_cycle_time
		cycle_timer.start()


func shoot():
	var bullet_order = ["eb_diamond", "eb_square", "eb_round", "eb_round_big"]
	for i in range(bullet_count):
		var bullet_angle = angle + (TAU / bullet_count) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet(bullet_order[bullet_index])
		bullet.initialize(global_position, direction, bullet_speed, direction.angle())
		
	if bullet_index >= 3:
		bullet_index = 0
		bullet_speed = 200
	else:
		bullet_index += 1
		bullet_speed -= 20
	angle += angle_increment
	burst_count += 1


func _on_shot_timer_timeout():
	if is_attacking and burst_count < max_burst_shots:
		shoot()
		shot_timer.start()


func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()
