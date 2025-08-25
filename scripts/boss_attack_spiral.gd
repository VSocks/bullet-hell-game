extends Node2D

var is_attacking : bool = false
var burst_count : int = 0
var max_burst_shots : int = 1
var shot_interval : float = 0.1
var cooldown : float = 0.25
var total_cycle_time : float = (max_burst_shots * shot_interval) + cooldown + 0.1

var bullet_count : int = 36
var angle : float = 0.0
var angle_increment : float = 60

var bullets = ["eb_diamond", "eb_laser", "eb_missile", "eb_round", "eb_round_big", "eb_square"]
var bullet_index : int = 0


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
		bullet_index += 1
		if bullet_index >= 6:
			bullet_index = 0
		burst_count = 0
		angle = 0
		shot_timer.wait_time = shot_interval
		shot_timer.start()
		shoot()
		cycle_timer.wait_time = total_cycle_time
		cycle_timer.start()


func shoot():
	for i in range(bullet_count):
		var bullet_angle = angle + (TAU / bullet_count) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		var bullet = BulletPool.get_bullet(bullets[bullet_index])
		bullet.initialize(global_position, direction, 300, direction.angle())
	
	angle += angle_increment
	burst_count += 1


func _on_shot_timer_timeout():
	if is_attacking and burst_count < max_burst_shots:
		shoot()
		shot_timer.start()


func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()
