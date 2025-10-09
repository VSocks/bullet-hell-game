extends Node
class_name EnemySpawner

var spawn_queue: Array = []
var current_index: int = 0
var is_spawning: bool = false

@onready var timer = $Timer


func _ready():
	create_spawn_list()
	await get_tree().create_timer(1.0).timeout
	start_spawning()


func create_spawn_list():
	var basic_enemy = preload("res://scenes/enemies/enemy.tscn")
	var sine_path = preload("res://scenes/paths/sine_descent_small.tscn")
	var single_shot = load("res://scripts/enemy_scripts/normal_attack/single_shot_attack.gd")
	
	var spawn_list = []
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(200, 50), single_shot, 2.0
	))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(200, 100), single_shot, 2.0
	))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(200, 50), single_shot, 2.0
	))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(250, 50), single_shot, 2.0,
		deg_to_rad(0), Vector2.ONE, true
	))
	
	# Same path but going UP (flipped vertically)
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(225, 700), single_shot, 1.0,
		deg_to_rad(0), Vector2.ONE, false, true  # flip_v = true
	))
	
	# Same path but going LEFT (rotated 90 degrees)
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(500, 300), single_shot, 1.0,
		deg_to_rad(-90)  # rotated 90 degrees
	))
	
	# Same path but going RIGHT (rotated -90 degrees)
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(-50, 200), single_shot, 1.0,
		deg_to_rad(90)  # rotated -90 degrees
	))
	
	# Sine wave path scaled larger
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(200, -50), single_shot, 2.0,
		0.0, Vector2(1.5, 1.5)  # 1.5x scale
	))
	
	# Sine wave path scaled smaller
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(300, -50), single_shot, 0.0,
		0.0, Vector2(0.7, 0.7)  # 0.7x scale
	))
	
	# Diagonal path (45 degrees)
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, sine_path, Vector2(-100, -100), single_shot, 2.0,
		deg_to_rad(-45)  # 45 degrees
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
		timer.stop()
		return
	
	var spawn_data = spawn_queue[current_index]
	
	# Create Path2D structure
	var path_instance = spawn_data["path_scene"].instantiate()
	path_instance.position = spawn_data["spawn_position"]
	
	# Apply transformations if specified
	if spawn_data.has("path_rotation") and spawn_data.path_rotation != 0:
		path_instance.rotation = spawn_data["path_rotation"]
		#print("rotating path of enemy ", current_index)
	if spawn_data.has("path_scale") and spawn_data.path_scale != Vector2.ONE:
		path_instance.scale = spawn_data["path_scale"]
		#print("scaling path of enemy ", current_index)
	if spawn_data.has("path_flip_h") and spawn_data.path_flip_h == true:
		path_instance.scale.x *= -1
		#print("flipping h of enemy ", current_index)
	if spawn_data.has("path_flip_v") and spawn_data.path_flip_h == true:
		path_instance.scale.y *= -1
		#print("flipping v of enemy ", current_index)
	
	# Spawn the enemy and attach to PathFollow2D
	var enemy_instance = spawn_data["enemy_scene"].instantiate()
	
	# Find or create PathFollow2D node
	var path_follow = path_instance.get_node("PathFollow2D")
	if not path_follow:
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
	print("Spawned enemy on transformed path at position: ", spawn_data["spawn_position"])
	
	current_index += 1
	
	# Schedule next spawn
	if current_index < spawn_queue.size():
		var delay = spawn_data["delay_until_next"]
		
		if delay <= 0:
			spawn_next_enemy()
		else:
			timer.wait_time = delay
			timer.start()


func _on_timer_timeout():
	spawn_next_enemy()

# Enhanced helper function with transformation parameters
static func create_spawn_data(
	enemy_scene: PackedScene, 
	path_scene: PackedScene, 
	spawn_position: Vector2, 
	attack_script: Script = null, 
	delay: float = 1.0,
	path_rotation: float = 0.0,
	path_scale: Vector2 = Vector2.ONE,
	path_flip_h: bool = false,
	path_flip_v: bool = false
) -> Dictionary:
	
	return {
		"enemy_scene": enemy_scene,
		"path_scene": path_scene,
		"spawn_position": spawn_position,
		"attack_script": attack_script,
		"delay_until_next": delay,
		"path_rotation": path_rotation,
		"path_scale": path_scale,
		"path_flip_h": path_flip_h,
		"path_flip_v": path_flip_v
	}
