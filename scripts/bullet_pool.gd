extends Node
# REMOVE class_name BulletPool - autoload name is enough

var bullet_scene : PackedScene = preload("res://scenes/enemy_bullet_round.tscn")

var pool_size : int = 600
var available_bullets : Array = []


func _ready():
	# Pre-instantiate bullets
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		_reset_bullet(bullet)
		add_child(bullet)
		available_bullets.append(bullet)
	print("Bullet pool initialized with ", pool_size, " bullets")


func get_bullet() -> Node:
	if available_bullets.is_empty():
		# Create emergency bullet if pool is empty
		var new_bullet = bullet_scene.instantiate()
		add_child(new_bullet)
		print("EMERGENCY: Pool empty, created new bullet")
		return new_bullet
	
	var bullet = available_bullets.pop_back()
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	# Re-enable collision safely
	bullet.set_deferred("monitoring", true)
	bullet.set_deferred("monitorable", true)
	return bullet


func return_bullet(bullet: Node):
	# Use call_deferred to avoid physics callback issues
	call_deferred("_reset_bullet_deferred", bullet)


func _reset_bullet_deferred(bullet: Node):
	_reset_bullet(bullet)
	available_bullets.append(bullet)


func _reset_bullet(bullet: Node):
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	bullet.position = Vector2(-1000, -1000)
	# Disable collision safely
	bullet.monitoring = false
	bullet.monitorable = false
