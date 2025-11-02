extends Node2D

var stage_clear_menu = preload("res://scenes/menus/stage_clear.tscn")

func _ready():
	BulletPool.initialize_pool()
	


func _on_enemy_spawner_stage_clear():
	var stage_clear = stage_clear_menu.instantiate()
	stage_clear.position = Vector2(0, 0)
	await get_tree().create_timer(2.0).timeout
	add_child(stage_clear)
	print_debug("added stage clear menu")
