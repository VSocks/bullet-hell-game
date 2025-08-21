extends Node
# REMOVE class_name BulletPool - autoload name is enough

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_round.tscn")
var pool_size : int = 200
var available_bullets : Array = []


func _ready():
	# Pre-instantiate bullets
	for i in range(pool_size):
		var bullet = create_new_bullet()
		available_bullets.append(bullet)
	print("Bullet pool initialized with ", pool_size, " bullets")


func create_new_bullet() -> Node:
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	return bullet


func get_bullet() -> Node:
	if available_bullets.is_empty():
		# Create emergency bullet if pool is empty
		var new_bullet = create_new_bullet()
		print("EMERGENCY: Pool empty, created new bullet")
		return prepare_bullet(new_bullet)
	
	var bullet = available_bullets.pop_back()
	return prepare_bullet(bullet)


func prepare_bullet(bullet: Node) -> Node:
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	return bullet


func return_bullet(bullet: Node):
	if bullet in available_bullets:
		return  # Already in pool
	
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	bullet.position = Vector2(-1000, -1000)  # Move off-screen
	available_bullets.append(bullet)
