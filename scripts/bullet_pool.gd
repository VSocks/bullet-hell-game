extends Node

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_missile.tscn")
var pool_size : int = 0
var available_bullets : Array = []
var expansion : int = 0


func _ready():
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(bullet)
		available_bullets.append(bullet)
	print("Bullet pool initialized with ", pool_size, " bullets")	


func return_bullet(bullet: Area2D) -> void:
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	bullet.position = Vector2(-1000, -1000)  # Move off-screen
	available_bullets.append(bullet)
	print("Bullet returned to pool!")


func get_bullet() -> Area2D:
	var bullet : Area2D
	if available_bullets.is_empty():
		bullet = bullet_scene.instantiate()
		add_child(bullet)
		expansion += 1
		print("New bullet created, bullet pool expanded to size ", pool_size + expansion)
	else:
		bullet = available_bullets.pop_back()
		print("Bullet pulled from pool!")
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	bullet.play_sound()
	return bullet
