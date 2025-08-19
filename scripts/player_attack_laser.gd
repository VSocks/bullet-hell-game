extends Node2D

var bullet_scene_laser : PackedScene = preload("res://scenes/player_bullet_laser.tscn")

var spread_angle : float
var bullet_count : int = 9
var fire_rate : float = 0.05

@onready var fire_rate_timer = $FireRateTimer


func start_attack():
	spread_angle = deg_to_rad(3 * bullet_count)
	fire_rate_timer.wait_time = fire_rate
	fire_rate_timer.start()


func stop_attack():
	fire_rate_timer.stop()


func _on_fire_rate_timer_timeout():
	var angle_step = spread_angle / (bullet_count - 1) if bullet_count > 1 else 0
	var start_angle = -spread_angle / 2
	for i in range(bullet_count):
		var current_angle = start_angle + (angle_step * i)
		var direction = Vector2(0, -1).rotated(current_angle)
		var bullet = bullet_scene_laser.instantiate()
		bullet.global_position = global_position
		bullet.global_position.y -= 10
		bullet.direction = direction
		bullet.speed = 800
		bullet.rotation = direction.angle() + PI /2
		get_tree().current_scene.add_child(bullet)
