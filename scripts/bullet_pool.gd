extends Node2D
class_name BulletPool

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_round.tscn")
var pool_size : int = 100
var bullet_pool : Array = []
var available_bullets : Array = []

func _ready():
	# Pre-instantiate bullets
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		bullet.pool_manager = self  # Set reference to pool
		add_child(bullet)
		bullet_pool.append(bullet)
		available_bullets.append(bullet)
	print("Bullet pool initialized with ", pool_size, " bullets")

func get_bullet() -> Bullet:
	if available_bullets.is_empty():
		# Expand pool if no bullets available
		var new_bullet = create_new_bullet()
		print("Pool expanded to: ", bullet_pool.size())
		return new_bullet
	
	var bullet = available_bullets.pop_back()
	bullet.setup(bullet.direction, bullet.speed, self)
	return bullet

func return_bullet(bullet: Bullet):
	if not available_bullets.has(bullet):
		available_bullets.append(bullet)
	# Reset bullet properties
	bullet.position = Vector2(-1000, -1000)  # Move off-screen

func create_new_bullet() -> Bullet:
	var new_bullet = bullet_scene.instantiate()
	new_bullet.visible = false
	new_bullet.process_mode = Node.PROCESS_MODE_DISABLED
	new_bullet.pool_manager = self
	add_child(new_bullet)
	bullet_pool.append(new_bullet)
	available_bullets.append(new_bullet)
	return new_bullet

func get_available_count() -> int:
	return available_bullets.size()

func get_total_count() -> int:
	return bullet_pool.size()
	
