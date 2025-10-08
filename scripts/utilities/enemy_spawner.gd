extends Node
class_name EnemySpawner

var spawn_queue: Array = []
var current_index: int = 0
var is_spawning: bool = false

@onready var timer = $Timer


func _ready():
	await get_tree().create_timer(1.0).timeout
	create_enemy_wave_with_groups()
	start_spawning()

func create_enemy_wave_with_groups():
	var basic_enemy = preload("res://scenes/enemies/enemy.tscn")
	var boss = preload("res://scenes/bosses/boss.tscn")
	
	var straight_move = load("res://scripts/enemy_scripts/movement/straight_down_movement.gd")
	var sine_move = load("res://scripts/enemy_scripts/movement/sine_wave_movement.gd")
	
	var alternating_attack = load("res://scripts/enemy_scripts/normal_attack/alternating_sides_attack.gd")
	var circle_attack = load("res://scripts/enemy_scripts/normal_attack/circle_attack.gd")
	var cross_attack = load("res://scripts/enemy_scripts/normal_attack/cross_attack.gd")
	var fan_attack = load("res://scripts/enemy_scripts/normal_attack/fan_attack.gd")
	var grid_attack = load("res://scripts/enemy_scripts/normal_attack/grid_attack.gd")
	var layer_circle_attack = load("res://scripts/enemy_scripts/normal_attack/layer_circle_attack.gd")
	var single_shot = load("res://scripts/enemy_scripts/normal_attack/single_shot_attack.gd")
	var spiral_attack = load("res://scripts/enemy_scripts/normal_attack/spiral_attack.gd")
	var wave_attack = load("res://scripts/enemy_scripts/normal_attack/wave_attack.gd")
	
	var spawn_list = []
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(200, -50), sine_move, fan_attack, 0.0))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(300, -50), sine_move, fan_attack, 0.0))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(400, -50), sine_move, fan_attack, 2.0))
	
	for i in range(5):
		var positions = [Vector2(100, -50), Vector2(200, -80), Vector2(300, -100), Vector2(400, -80), Vector2(500, -50)]
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, positions[i], straight_move, fan_attack, 0.0))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(-50, 200), straight_move, fan_attack, 0.0))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(650, 200), straight_move, fan_attack, 0.0))
	
	#spawn_list.append(EnemySpawner.create_spawn_data(
	#	boss, Vector2(300, 50), null, null, 3.0
	#))
	
	setup_spawn_list(spawn_list)


func setup_spawn_list(spawn_list: Array):
	spawn_queue = spawn_list.duplicate()
	print("Setup spawn list with ", spawn_queue.size(), " enemies")


func start_spawning():
	if spawn_queue.is_empty():
		print("No enemies to spawn!")
		timer.stop()
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
	
	var enemy_instance = spawn_data["enemy_scene"].instantiate()
	enemy_instance.position = spawn_data["spawn_position"]
	
	# Attach movement script
	if spawn_data.get("movement_script") and enemy_instance.has_node("Movement"):
		enemy_instance.get_node("Movement").set_script(spawn_data["movement_script"])
	
	# Attach attack script  
	if spawn_data.get("attack_script") and enemy_instance.has_node("Attack"):
		enemy_instance.get_node("Attack").set_script(spawn_data["attack_script"])
	
	get_parent().add_child(enemy_instance)
	print("Spawned enemy ", current_index + 1, " at ", spawn_data["spawn_position"])
	
	current_index += 1
	
	if current_index < spawn_queue.size():
		var delay = spawn_data["delay_until_next"]
		
		if delay <= 0:
			# Instant spawn - call immediately
			spawn_next_enemy()
		else:
			# Delayed spawn - use timer
			timer.wait_time = delay
			timer.start()


func _on_timer_timeout():
	spawn_next_enemy()


static func create_spawn_data(scene: PackedScene, pos: Vector2, move_script: Script = null, attack_script: Script = null, delay: float = 1.0) -> Dictionary:
	return {
		"enemy_scene": scene,
		"spawn_position": pos,
		"movement_script": move_script,
		"attack_script": attack_script,
		"delay_until_next": delay
	}
