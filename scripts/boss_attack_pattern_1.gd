extends Node2D

var bullet_scene : PackedScene = load("res://scenes/bullet.tscn")

var angle : float = 0.0
var spiral_speed : float = 5.0
var bullet_count : int = 4
var bullet


func _on_boss_shoot_1():
	for i in range(bullet_count):
		bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		var direction = Vector2(cos(angle), sin(angle))
		bullet.global_position = global_position
		bullet.direction = direction
		bullet.speed = 150
		angle += 2 * PI / bullet_count
	angle += 0.25
