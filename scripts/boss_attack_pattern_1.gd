extends Node2D

var bullet_scene_round : PackedScene = preload("res://scenes/enemy_bullet_round.tscn")

var angle : float = 0.0
var spiral_speed : float = 5.0
var bullet_count : int = 4

func _on_boss_shoot_1():
	for i in range(bullet_count):
		var bullet = bullet_scene_round.instantiate()
		var direction = Vector2(cos(angle), sin(angle))
		bullet.global_position = global_position
		bullet.direction = direction
		bullet.speed = 150
		bullet.rotation = direction.angle() + PI /2 
		get_tree().current_scene.add_child(bullet)
		angle += 2 * PI / bullet_count
	angle += 0.25
