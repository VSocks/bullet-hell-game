extends Node
class_name EnemySpawner

var spawn_queue: Array = []
var current_index: int = 0
var is_spawning: bool = false

@onready var timer = $Timer


func _ready():
	create_spawn_list()
	await get_tree().create_timer(5.0).timeout
	start_spawning()


func create_spawn_list():
	# Enemies
	var basic_enemy = preload("res://scenes/enemies/enemy1.tscn")
	var tough_enemy = preload("res://scenes/enemies/enemy2.tscn")
	var boss = preload("res://scenes/bosses/boss.tscn")
	
	# Paths
	var curve_descent = preload("res://scenes/paths/curve_descent.tscn")
	var jump = preload("res://scenes/paths/parable_jump.tscn")
	var loop = preload("res://scenes/paths/loop.tscn")
	var sharp_descent = preload("res://scenes/paths/sharp_descent.tscn")
	var side_straight = preload("res://scenes/paths/straight_side.tscn")
	var side_jump = preload("res://scenes/paths/jump_from_side.tscn")
	var small_sine = preload("res://scenes/paths/sine_descent_small.tscn")
	var straight = preload("res://scenes/paths/straight_down.tscn")
	var wide_sine = preload("res://scenes/paths/sine_descent_wide.tscn")
	
	# Path scripts
	var slow_default = load("res://scripts/enemy_scripts/paths/slow_speed_default.gd")
	var medium_default = load("res://scripts/enemy_scripts/paths/medium_speed_default.gd")
	var fast_default = load("res://scripts/enemy_scripts/paths/fast_speed_default.gd")
	var pause_point = load("res://scripts/enemy_scripts/paths/trigger_point_pause.gd")
	var shoot_point = load("res://scripts/enemy_scripts/paths/trigger_point_shoot.gd")
	var pause_shoot_point = load("res://scripts/enemy_scripts/paths/trigger_point_pause_shoot.gd")
	
	# Attacks
	var aimed_shotgun = load("res://scripts/enemy_scripts/normal_attack/aimed_shotgun.gd")
	var aimed_single = load("res://scripts/enemy_scripts/normal_attack/aimed_single_shot.gd")
	var circle = load("res://scripts/enemy_scripts/normal_attack/circle_attack.gd")
	var continuous_aimed_single = load("res://scripts/enemy_scripts/normal_attack/continuous_aimed_single.gd")
	var layer_circle = load("res://scripts/enemy_scripts/normal_attack/layer_circle_attack.gd")
	var single_shot = load("res://scripts/enemy_scripts/normal_attack/single_shot_attack.gd")
	
	var spawn_list = []
	var last_delay
	
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		tough_enemy, straight, Vector2(300, -50), circle, pause_shoot_point, 1.5
		))
	
	for i in range(6):
		last_delay = 0.5 * floor(i / 5)
		var flip_h = false
		if i < 3:
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, sharp_descent, Vector2(i * 100 + 50, -50), single_shot, pause_shoot_point, 0.05 + last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	for i in range(5):
		last_delay = 0.5 * floor(i / 4)
		var flip_h = false
		if i < 3:
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, sharp_descent, Vector2(i * 100 + 100, -75), single_shot, pause_shoot_point, 0.05 + last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	for i in range(6):
		last_delay = 1.5 * floor(i / 5)
		var flip_h = false
		if i < 3:
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, sharp_descent, Vector2(i * 100 + 50, -100), single_shot, pause_shoot_point, 0.05 + last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	for i in range(40):
		last_delay = floor(i / 39)
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, wide_sine, Vector2(150, -50), continuous_aimed_single, slow_default, 0.2 + last_delay
			))
	
	for j in range(3):
		for i in range(2):
			last_delay = floor((j + i) / 3)
			spawn_list.append(EnemySpawner.create_spawn_data(
				tough_enemy, straight, Vector2(i * 500 + 50, -50), aimed_shotgun, shoot_point, 0.5 + last_delay,
				))
	
	for i in range(15):
		last_delay = 2 * floor(i / 14)
		spawn_list.append(EnemySpawner.create_spawn_data(
			tough_enemy, loop, Vector2(-50, 300 + i * 15), circle, shoot_point, 0.2 + last_delay,
			))
	
	for i in range(15):
		last_delay = floor(i / 14)
		spawn_list.append(EnemySpawner.create_spawn_data(
			tough_enemy, loop, Vector2(650, 300 - i * 15), circle, shoot_point, 0.2 + last_delay,
			deg_to_rad(0), Vector2.ONE, true, true
			))
	
	for i in range(15):
		last_delay = 2 * floor(i / 14)
		spawn_list.append(EnemySpawner.create_spawn_data(
			tough_enemy, loop, Vector2(300 - i * 15, -50), circle, shoot_point, 0.2 + last_delay,
			deg_to_rad(90), Vector2.ONE
			))
	
	for i in range(60):
		last_delay = 2 * floor(i / 59)
		var side = -70
		var offset = i * 2
		var flip_h = false
		if i % 2 == 0:
			side = 670
			flip_h = true
		if i % 3 == 0:
			spawn_list.append(EnemySpawner.create_spawn_data(
				basic_enemy, jump, Vector2(side, 600), circle, shoot_point, 0.1 + last_delay,
				deg_to_rad(0), Vector2.ONE, flip_h
				))
		else:
			spawn_list.append(EnemySpawner.create_spawn_data(
				basic_enemy, side_jump, Vector2(side, 220 + offset), circle, shoot_point, 0.1 + last_delay,
				deg_to_rad(0), Vector2.ONE, flip_h
				))
	
	for i in range(6):
		last_delay = 0.5 * floor(i / 5)
		var flip_h = false
		if i % 2 != 0:
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, sharp_descent, Vector2(i * 100 + 50, -50), single_shot, pause_shoot_point, last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	for i in range(7):
		last_delay = 0.5 * floor(i / 6)
		var flip_h = false
		if i % 2 != 0:
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, sharp_descent, Vector2(i * 100, -75), single_shot, pause_shoot_point, last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	for i in range(6):
		last_delay = 0.5 * floor(i / 5)
		var flip_h = false
		if i % 2 != 0:
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, sharp_descent, Vector2(i * 100 + 50, -100), single_shot, pause_shoot_point, last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	for i in range(7):
		last_delay = 3 * floor(i / 6)
		var flip_h = false
		if i % 2 != 0:
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, sharp_descent, Vector2(i * 100, -125), single_shot, pause_shoot_point, last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	for i in range(25):
		last_delay = 1.5 * floor(i / 24)
		if i % 2 == 0:
			var pos = Vector2(i * 15 + 50, -50)
			spawn_list.append(EnemySpawner.create_spawn_data(
				basic_enemy, curve_descent, pos, circle, shoot_point, 0.1 + last_delay,
				))
		else:
			spawn_list.append(EnemySpawner.create_spawn_data(
				basic_enemy, jump, Vector2(-50, 550), aimed_single, shoot_point, 0.1 + last_delay
				))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		tough_enemy, straight, Vector2(300, -50), layer_circle, pause_shoot_point, 0.0
		))
	
	for i in range(25):
		last_delay = 1.5 * floor(i / 24)
		if i % 2 == 0:
			var pos = Vector2(i * -15 + 550, -50)
			spawn_list.append(EnemySpawner.create_spawn_data(
				basic_enemy, curve_descent, pos, circle, shoot_point, 0.1 + last_delay,
				deg_to_rad(0), Vector2.ONE, true
				))
		else:
			spawn_list.append(EnemySpawner.create_spawn_data(
				basic_enemy, jump, Vector2(650, 550), aimed_shotgun, shoot_point, 0.1 + last_delay,
				deg_to_rad(0), Vector2.ONE, true
				))
	
	for i in range(10):
		last_delay = floor(i / 9)
		var pos = Vector2(-i * 25 + 250, -50 - i * 10)
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, small_sine, pos, continuous_aimed_single, slow_default, 0.1 + last_delay
			))
	
	for i in range(10):
		last_delay = floor(i / 9)
		var pos = Vector2(-i * 25 + 300, -50 - i * 10)
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, small_sine, pos, continuous_aimed_single, slow_default, 0.1 + last_delay
			))
	
	for i in range(10):
		last_delay = floor(i / 9)
		var pos = Vector2(-i * 25 + 350, -50 - i * 10)
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, small_sine, pos, continuous_aimed_single, slow_default, 0.1 + last_delay
			))
	
	for i in range(10):
		last_delay = 3 * floor(i / 9)
		var pos = Vector2(-i * 25 + 400, -50 - i * 10)
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, small_sine, pos, continuous_aimed_single, slow_default, 0.1 + last_delay
			))
	
	for i in range(2):
		last_delay = 3 * i
		spawn_list.append(EnemySpawner.create_spawn_data(
			tough_enemy, straight, Vector2(300 * i + 150, -50), layer_circle, pause_shoot_point, last_delay
			))
	
	for i in range(10):
		last_delay = 2 * floor(i / 9)
		var flip_h = false
		var side = -50
		if i % 2 == 0:
			side = 650
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, side_straight, Vector2(side, abs(-i * 25 + 135)), aimed_shotgun, shoot_point, 0.35 + last_delay,
			deg_to_rad(0), Vector2.ONE, flip_h
			))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		tough_enemy, straight, Vector2(300, -50), layer_circle, pause_shoot_point, 0.0
		))
	
	for i in range(20):
		last_delay = floor(i / 19)
		var side = -50
		var flip_h = false
		if i % 2 == 0:
			side = 650
			flip_h = true
		spawn_list.append(EnemySpawner.create_spawn_data(
				basic_enemy, jump, Vector2(side, 550), aimed_shotgun, shoot_point, 0.1 + last_delay,
				deg_to_rad(0), Vector2.ONE, flip_h
				))
		

	setup_spawn_list(spawn_list)


func setup_spawn_list(spawn_list: Array):
	spawn_queue = spawn_list.duplicate()


func start_spawning():
	if spawn_queue.is_empty():
		print_debug("No enemies to spawn!")
		return
	
	is_spawning = true
	spawn_next_enemy()


func spawn_next_enemy():
	if current_index >= spawn_queue.size():
		print_debug("All enemies spawned!")
		is_spawning = false
		timer.stop()
		return
	
	var spawn_data = spawn_queue[current_index]
	
	var path_instance = spawn_data["path_scene"].instantiate()
	path_instance.position = spawn_data["spawn_position"]
	
	if spawn_data.has("path_rotation") and spawn_data.path_rotation != 0:
		path_instance.rotation = spawn_data["path_rotation"]
		#print_debug("rotating path of enemy ", current_index)
	if spawn_data.has("path_scale") and spawn_data.path_scale != Vector2.ONE:
		path_instance.scale = spawn_data["path_scale"]
		#print_debug("scaling path of enemy ", current_index)
	if spawn_data.has("path_flip_h") and spawn_data.path_flip_h == true:
		path_instance.scale.x *= -1
		#print_debug("flipping h of enemy ", current_index)
	if spawn_data.has("path_flip_v") and spawn_data.path_flip_v == true:
		path_instance.scale.y *= -1
		#print_debug("flipping v of enemy ", current_index)
	
	# Find or create PathFollow2D node
	var path_follow = path_instance.get_node("PathFollow2D")
	if not path_follow:
		path_follow = PathFollow2D.new()
		path_instance.add_child(path_follow)
		path_follow.owner = path_instance
	
	# Attach PathFollow2D script if specified
	if spawn_data.get("pathfollow_script") and path_follow:
		path_follow.set_script(spawn_data["pathfollow_script"])
		#print_debug("Attached pathfollow script: ", spawn_data["pathfollow_script"].resource_path.get_file())
	
	# Spawn the enemy and attach to PathFollow2D
	var enemy_instance = spawn_data["enemy_scene"].instantiate()
	path_follow.add_child(enemy_instance)
	enemy_instance.owner = path_instance
	
	# Attach attack script if specified
	if spawn_data.get("attack_script") and enemy_instance.has_node("Attack"):
		enemy_instance.get_node("Attack").set_script(spawn_data["attack_script"])
		#print_debug("Attached attack script: ", spawn_data["attack_script"].resource_path.get_file())
	
	# Add the complete path structure to the scene
	get_parent().add_child(path_instance)
	#print_debug("Spawned enemy with at position: ", spawn_data["spawn_position"])
	
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


static func create_spawn_data(
	enemy_scene: PackedScene, 
	path_scene: PackedScene, 
	spawn_position: Vector2, 
	attack_script: Script = null, 
	pathfollow_script: Script = null,
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
		"pathfollow_script": pathfollow_script,
		"delay_until_next": delay,
		"path_rotation": path_rotation,
		"path_scale": path_scale,
		"path_flip_h": path_flip_h,
		"path_flip_v": path_flip_v
	}
