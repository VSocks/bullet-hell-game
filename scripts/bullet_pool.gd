extends Node2D
class_name BulletPool

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_round.tscn")
var pool_size : int = 1800  # Adjust based on your needs
var bullet_pool : Array = []

func _ready():
	# Pre-instantiate bullets
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(bullet)
		bullet_pool.append(bullet)

func get_bullet() -> Bullet:
	# Try to find an available bullet
	for bullet in bullet_pool:
		if not bullet.visible:
			bullet.process_mode = Node.PROCESS_MODE_INHERIT
			bullet.visible = true
			return bullet
	
	# If no available bullets, create a new one (dynamic expansion)
	var new_bullet = bullet_scene.instantiate()
	add_child(new_bullet)
	bullet_pool.append(new_bullet)
	print("Pool expanded to: ", bullet_pool.size())
	return new_bullet

func return_bullet(bullet: Bullet):
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	bullet.position = Vector2(-1000, -1000)  # Move off-screen
