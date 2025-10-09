extends Node
class_name EnemySpawner

var spawn_queue: Array = []
var current_index: int = 0
var is_spawning: bool = false

@onready var timer = $Timer


func _ready():
	create_waves()
	await get_tree().create_timer(1.0).timeout
	start_spawning()


func create_waves():
	# Preload enemy scene
	var basic_enemy = preload("res://scenes/enemies/enemy.tscn")
	
	# Preload path scenes
	var curve_descent_wide = preload("res://scenes/paths/curve_descent_wide.tscn")

	# Preload attack scripts
	var single_shot = load("res://scripts/enemy_scripts/normal_attack/single_shot_attack.gd")
	
	var spawn_list = []
	
	# Enemy 1: Straight down path with attacks
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy,
		curve_descent_wide,
		Vector2(0, -100),
		single_shot,
		2.0
	))
	
	# Enemy 2: Sine wave path (spawns instantly after first)
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy,
		curve_descent_wide,
		Vector2(50, -100), 
		single_shot,
		0.0
	))
	
	# Enemy 3: Looping path above player
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy,
		curve_descent_wide,
		Vector2(50, 150),
		single_shot,
		3.0
	))
	
	# Enemy 4: Back and forth path (no attacks)
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy,
		curve_descent_wide,
		Vector2(75, 100),
		null,  # No attacks
		1.5
	))
	
	# Group of enemies on the same path pattern
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy,
		curve_descent_wide,
		Vector2(-25, -100),
		single_shot,
		0.0
	))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy,
		curve_descent_wide,
		Vector2(50, -100),
		single_shot, 
		0.0
	))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy,
		curve_descent_wide,
		Vector2(0, -100),
		single_shot,
		0.0
	))
	
	setup_spawn_list(spawn_list)


func setup_spawn_list(spawn_list: Array):
	spawn_queue = spawn_list.duplicate()
	print("Setup spawn list with ", spawn_queue.size(), " enemies")


func start_spawning():
	if spawn_queue.is_empty():
		print("No enemies to spawn!")
		return
	
	is_spawning = true
	spawn_next_enemy()


func spawn_next_enemy():
	if current_index >= spawn_queue.size():
		print("All enemies spawned!")
		is_spawning = false
		return
	
	var spawn_data = spawn_queue[current_index]
	
	# Create Path2D structure
	var path_instance = spawn_data["path_scene"].instantiate()
	path_instance.position = spawn_data["spawn_position"]
	
	# Spawn the enemy and attach to PathFollow2D
	var enemy_instance = spawn_data["enemy_scene"].instantiate()
	
	# Find the PathFollow2D node (assuming it's a direct child)
	var path_follow = path_instance.get_node("PathFollow2D")
	if not path_follow:
		# If no PathFollow2D exists, create one
		path_follow = PathFollow2D.new()
		path_instance.add_child(path_follow)
		path_follow.owner = path_instance
	
	# Add enemy as child of PathFollow2D
	path_follow.add_child(enemy_instance)
	enemy_instance.owner = path_instance
	
	# Attach attack script if specified
	if spawn_data.get("attack_script") and enemy_instance.has_node("Attack"):
		enemy_instance.get_node("Attack").set_script(spawn_data["attack_script"])
	
	# Add the complete path structure to the scene
	get_parent().add_child(path_instance)
	print("Spawned enemy on path at position: ", spawn_data["spawn_position"])
	
	current_index += 1
	
	# Schedule next spawn
	if current_index < spawn_queue.size():
		var delay = spawn_data["delay_until_next"]
		
		if delay <= 0:
			# Instant spawn
			spawn_next_enemy()
		else:
			# Delayed spawn
			timer.wait_time = delay
			timer.start()


func _on_timer_timeout():
	spawn_next_enemy()


static func create_spawn_data(enemy_scene: PackedScene, path_scene: PackedScene, spawn_position: Vector2, attack_script: Script = null, delay: float = 1.0) -> Dictionary:
	return {
		"enemy_scene": enemy_scene,
		"path_scene": path_scene,
		"spawn_position": spawn_position,
		"attack_script": attack_script,
		"delay_until_next": delay
	}
