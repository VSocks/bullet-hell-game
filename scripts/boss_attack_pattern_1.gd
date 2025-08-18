extends Node2D

var bullet_scene_arrowhead : PackedScene = preload("res://scenes/enemy_bullet_arrowhead.tscn")

var angle : float = 0.0
var spiral_speed : float = 5.0
var bullet_count : int = 4
var bullet


func _on_boss_shoot_1():
	for i in range(bullet_count):
		bullet = bullet_scene_arrowhead.instantiate()
		get_tree().current_scene.add_child(bullet)
		var direction = Vector2(cos(angle), sin(angle))
		bullet.global_position = global_position
		bullet.direction = direction
		bullet.rotation = direction.angle() + PI /2 
		bullet.speed = 150
		angle += 2 * PI / bullet_count
	angle += 0.25
