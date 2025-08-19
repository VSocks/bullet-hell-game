extends Node2D

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_laser.tscn")

# Burst firing parameters
var is_attacking : bool = false
var burst_count : int = 0
var max_burst_shots : int = 25  # 0.5 seconds at 0.1s interval = 5 shots
var shot_interval : float = 0.01  # Time between shots in burst
var cooldown_time : float = 1.0  # Time between bursts

# Spiral parameters
var bullet_count : int = 8
var spiral_speed : float = 5.0
var angle : float = 0.0

@onready var shot_timer = $ShotTimer
@onready var cooldown_timer = $CooldownTimer

func start_attack():
	is_attacking = true
	burst_count = 0
	start_burst()
	print("Spiral attack started!")

func stop_attack():
	is_attacking = false
	shot_timer.stop()
	cooldown_timer.stop()
	print("Spiral attack stopped!")

func start_burst():
	if is_attacking:
		burst_count = 0
		shot_timer.wait_time = shot_interval
		shot_timer.start()
		shoot()  # Shoot immediately on burst start

func start_cooldown():
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.start()

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
	
	angle += spiral_speed * get_process_delta_time()
	burst_count += 1

func _on_shot_timer_timeout():
	if is_attacking and burst_count < max_burst_shots:
		shoot()
		shot_timer.start()  # Continue burst
	else:
		shot_timer.stop()
		start_cooldown()  # Start pause after burst

func _on_cooldown_timer_timeout():
	if is_attacking:
		start_burst()  # Start next burst after cooldown
