extends Node2D

var fire_rate: float = 0.25
var wave_phase: float = 0.0

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	shoot_wave()

func shoot_wave():
	# Create a sine wave pattern
	var base_angle = deg_to_rad(90)  # Downward
	var base_angle_2 = deg_to_rad(90)
	var wave_offset = sin(wave_phase) * deg_to_rad(80)  # ±30 degree wave
	var wave_offset_2 = sin(wave_phase) * deg_to_rad(-80)
	
	var direction = Vector2(cos(base_angle + wave_offset), sin(base_angle + wave_offset))
	var direction_2 = Vector2(cos(base_angle_2 + wave_offset_2), sin(base_angle_2 + wave_offset_2))
	
	var bullet = BulletPool.get_bullet("eb_missile")
	var bullet_2 = BulletPool.get_bullet("eb_missile")
	bullet.initialize(global_position, direction, 200, direction.angle() + TAU /2)
	bullet.define_tragectory("curved")
	bullet.define_curve(-0.3)
	bullet_2.initialize(global_position, direction_2, 200, direction_2.angle() + TAU/2)
	bullet_2.define_tragectory("curved")
	bullet_2.define_curve(-0.3)
	
	wave_phase += 0.25  # Move wave phase
