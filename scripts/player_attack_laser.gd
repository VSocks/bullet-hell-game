extends Node2D

var bullet_scene_laser : PackedScene = preload("res://scenes/player_bullet_laser.tscn")

var spread_angle : float
var bullet_count : int = 9
var fire_rate : float = 0.05
var speed : int = 800


@onready var fire_rate_timer = $FireRateTimer


func start_attack():
	spread_angle = deg_to_rad(3 * bullet_count)
	shoot()
	fire_rate_timer.wait_time = fire_rate
	fire_rate_timer.start()


func stop_attack():
	fire_rate_timer.stop()


func shoot():
	var attack_rotation = get_parent().rotation
	var angle_step = spread_angle / (bullet_count - 1)
	var start_angle = (-spread_angle / 2) + attack_rotation
	for i in range(bullet_count):
		var current_angle = start_angle + (angle_step * i)
		var direction = Vector2(0, -1).rotated(current_angle)
		var bullet = bullet_scene_laser.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.initialize(global_position, direction, speed, direction.angle())


func _on_fire_rate_timer_timeout():
	shoot()
