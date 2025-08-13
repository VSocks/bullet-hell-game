extends Node2D

var laser_scene : PackedScene = load("res://scenes/laser.tscn")


func _on_player_shoot() -> void:
	#um padrão de tiro do jogador
	#o plano é ele poder ou alternar entre diferentes padrões de tiro
	#ou poder ir ficando mais forte (ex mais lasers, homing) no mesmo
	var laser = laser_scene.instantiate()
	get_tree().current_scene.add_child(laser)
	laser.global_position = global_position
	laser.global_position.y -= 10
	print("shoot player laser signal received")
