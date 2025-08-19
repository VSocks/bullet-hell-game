extends Node2D

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_laser.tscn")

# Burst firing parameters
var is_attacking : bool = false
var burst_count : int = 0
var max_burst_shots : int = 36
var shot_interval : float = 0.01
var cooldown : float = 2
var total_cycle_time : float = (max_burst_shots * shot_interval) + cooldown

# Spiral parameters
var bullet_count : int = 16
var spiral_speed : float = 10.0
var angle : float = 0.0
var angle_increment : float = 6

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
	# Spiral shooting code
	for i in range(bullet_count):
		var bullet_angle = angle + (TAU / bullet_count) * i
		var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
		
		var bullet = bullet_scene.instantiate()
		bullet.direction = direction
		bullet.speed = 300
		bullet.rotation = direction.angle()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
	
	angle += angle_increment
	burst_count += 1

func _on_shot_timer_timeout():
	if is_attacking and burst_count < max_burst_shots:
		shoot()
		shot_timer.start()  # Continue burst

func _on_cycle_timer_timeout():
	if is_attacking:
		start_cycle()  # Start next cycle
