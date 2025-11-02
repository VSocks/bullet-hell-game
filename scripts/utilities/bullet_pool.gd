extends Node

var bullet_scenes : Dictionary = {
	"eb_diamond": preload("res://scenes/bullets/enemy_bullet_diamond.tscn"),
	"eb_laser": preload("res://scenes/bullets/enemy_bullet_laser.tscn"),
	"eb_missile": preload("res://scenes/bullets/enemy_bullet_missile.tscn"),
	"eb_round": preload("res://scenes/bullets/enemy_bullet_round.tscn"),
	"eb_round_big": preload("res://scenes/bullets/enemy_bullet_round_big.tscn"),
	"eb_square": preload("res://scenes/bullets/enemy_bullet_square.tscn"),
	"pb_explosive": preload("res://scenes/bullets/player_bullet_explosive.tscn"),
	"pb_laser": preload("res://scenes/bullets/player_bullet_laser.tscn"),
	"pb_explosion": preload("res://scenes/bullets/player_bullet_explosion.tscn"),
	"pb_spark": preload("res://scenes/bullets/player_laser_spark.tscn"),
	"death_explosion": preload("res://scenes/bullets/death_explosion.tscn")
}

const pool_size = [500, 500, 500, 500, 500, 500, 200, 200, 20, 20, 20]

var available_bullets : Dictionary = {}

func _ready():
	pass

func initialize_pool():
	clear_pool()
	
	var pool_size_index = 0
	for bullet_type in bullet_scenes.keys():
		available_bullets[bullet_type] = []
		for i in pool_size[pool_size_index]:
			var bullet = create_bullet(bullet_type)
			available_bullets[bullet_type].append(bullet)
		print_debug("Created pool of size ", pool_size[pool_size_index], " for bullet type ", bullet_type)
		pool_size_index += 1

func clear_pool():
	for bullet_type in available_bullets:
		for bullet in available_bullets[bullet_type]:
			if is_instance_valid(bullet):
				bullet.queue_free()
	available_bullets.clear()

func create_bullet(bullet_type: String) -> Area2D:
	var bullet_scene = bullet_scenes.get(bullet_type)
	if not bullet_scene:
		print_debug("Bullet type not found: " + bullet_type)
		return null
	
	var bullet = bullet_scene.instantiate()
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	
	bullet.set_meta("bullet_type", bullet_type)
	
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.add_child(bullet)
	else:
		add_child(bullet) # Fallback
	
	return bullet

func get_bullet(bullet_type: String) -> Area2D:
	if not bullet_scenes.has(bullet_type):
		print_debug("Unknown bullet type: " + bullet_type)
		bullet_type = "eb_round"  # Fallback
	
	var bullet_array = available_bullets.get(bullet_type, [])
	var bullet : Area2D
	
	# Clean up any invalid bullets first
	bullet_array = bullet_array.filter(func(b): return is_instance_valid(b))
	available_bullets[bullet_type] = bullet_array
	
	if bullet_array.is_empty():
		bullet = create_bullet(bullet_type)
		print_debug("Pool expanded for type: ", bullet_type)
	else:
		bullet = bullet_array.pop_back()
		# Double-check the bullet is still valid
		if not is_instance_valid(bullet):
			bullet = create_bullet(bullet_type)
	
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	return bullet

func return_bullet(bullet: Area2D) -> void:
	call_deferred("_deferred_return_bullet", bullet)

func _deferred_return_bullet(bullet: Area2D):
	# Check if bullet is still valid
	if not is_instance_valid(bullet):
		return
	
	var bullet_type = bullet.get_meta("bullet_type", "eb_round")
	
	if bullet.has_method("reset_bullet"):
		bullet.reset_bullet()
	else:
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		bullet.position = Vector2(-1000, -1000)
	
	if available_bullets.has(bullet_type):
		# Check if bullet is already in pool (shouldn't happen, but safety)
		if not available_bullets[bullet_type].has(bullet):
			available_bullets[bullet_type].append(bullet)
	else:
		bullet.queue_free()
