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
	var boss = preload("res://scenes/boss.tscn")
	var basic_enemy = preload("res://scenes/enemy.tscn")
	var straight_move = load("res://scripts/straight_down_movement.gd")
	var sine_move = load("res://scripts/sine_wave_movement.gd")
	var single_shot = load("res://scripts/single_shot_attack.gd")
	
	var spawn_list = []
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(200, -50), sine_move, single_shot, 0.0
	))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(400, -50), sine_move, single_shot, 0.0  
	))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(600, -50), sine_move, single_shot, 2.0
	))
	
	for i in range(5):
		var positions = [Vector2(10, 10), Vector2(20, 20), Vector2(30, 30), Vector2(40, 40), Vector2(50, 50)]
		spawn_list.append(EnemySpawner.create_spawn_data(
			basic_enemy, positions[i], straight_move, single_shot, 0.0
		))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(200, -50), straight_move, single_shot, 0.0
	))
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy, Vector2(600, -50), straight_move, single_shot, 0.0
	))
	
	# Wait 3 seconds
	spawn_list.append(EnemySpawner.create_spawn_data(
		boss, Vector2(400, 100), null, null, 3.0
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
	
	# Spawn the enemy
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
	
	# Schedule next spawn
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


# Helper function to create spawn data
static func create_spawn_data(scene: PackedScene, pos: Vector2, move_script: Script = null, attack_script: Script = null, delay: float = 1.0) -> Dictionary:
	return {
		"enemy_scene": scene,
		"spawn_position": pos,
		"movement_script": move_script,
		"attack_script": attack_script,
		"delay_until_next": delay
	}
