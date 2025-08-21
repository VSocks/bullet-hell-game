extends Node2D

# Burst firing parameters
var is_attacking : bool = false
var burst_count : int = 0
var max_burst_shots : int = 18
var shot_interval : float = 1
var cooldown : float = 1
var total_cycle_time : float = (max_burst_shots * shot_interval) + cooldown + 0.1

# Spiral parameters
var bullet_count : int = 36
var angle : float = 0.0
var angle_increment : float = 20


@onready var shot_timer = $ShotTimer
@onready var cycle_timer = $CycleTimer

func start_attack():
	is_attacking = true
	start_cycle()
	print("Spiral attack started!")


func stop_attack():
	is_attacking = false
	shot_timer.stop()
	cycle_timer.stop()
	print("Spiral attack stopped!")


func start_cycle():
	if is_attacking:
		burst_count = 0
		shot_timer.wait_time = shot_interval
		shot_timer.start()
		shoot()  # First shot
		cycle_timer.wait_time = total_cycle_time
		cycle_timer.start()  # Start the full cycle timer


func shoot():
	for i in range(bullet_count):
		var bullet_angle = angle + (TAU / bullet_count) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		
		# Get bullet from the global pool
		var bullet = BulletPool.get_bullet()
		bullet.position = global_position
		bullet.direction = direction
		bullet.rotation = direction.angle() + PI / 2
		bullet.speed = 400
	
	angle += angle_increment
	burst_count += 1


func _on_shot_timer_timeout():
	if is_attacking and burst_count < max_burst_shots:
		shoot()
		shot_timer.start()  # Continue burst


func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()  # Start next cycle
