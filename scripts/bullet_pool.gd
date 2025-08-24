extends Node

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_diamond.tscn")

const POOL_SIZE : int = 700

var available_bullets : Array = []
var expansion : int = 0
var this_level : Node


func _ready():
	this_level = get_tree().current_scene
	for i in range(POOL_SIZE):
		var bullet = bullet_scene.instantiate()
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		if this_level:
			this_level.add_child(bullet)
		else:
			add_child(bullet) # Fallback
			#print("Error, could not get tree")
		available_bullets.append(bullet)
	#print("Bullet pool initialized with ", pool_size, " bullets")	


func return_bullet(bullet: Area2D) -> void:
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	bullet.position = Vector2(-1000, -1000)
	available_bullets.append(bullet)
	#print("Bullet returned to pool!")


func get_bullet() -> Area2D:
	var bullet : Area2D
	if available_bullets.is_empty():
		bullet = bullet_scene.instantiate()
		if this_level:
			this_level.add_child(bullet)
		else:
			add_child(bullet) # Fallback
			#print("Error, could not get tree")
		expansion += 1
		#print("New bullet created, bullet pool expanded to size ", pool_size + expansion)
	else:
		bullet = available_bullets.pop_back()
		#print("Bullet pulled from pool!")
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	return bullet
