extends Node2D

var bullet_scene_laser : PackedScene = preload("res://scenes/player_bullet_laser.tscn")

var spread_angle : float = deg_to_rad(30)
var bullet_count : int = 7

func _on_player_shoot():
	var angle_step = spread_angle / (bullet_count - 1) if bullet_count > 1 else 0
	var start_angle = -spread_angle / 2
	for i in range(bullet_count):
		var current_angle = start_angle + (angle_step * i)
		var direction = Vector2(0, -1).rotated(current_angle)
		var bullet = bullet_scene_laser.instantiate()
		bullet.global_position = global_position
		bullet.direction = direction
		bullet.speed = 1000
		bullet.rotation = direction.angle() + PI /2
		get_tree().current_scene.add_child(bullet)
