extends Node2D

var bullet_scene : PackedScene = preload("res://scenes/player_bullet.tscn")


func _on_player_shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.global_position.y -= 10
