extends Node
class_name EnemySpawner

var spawn_queue: Array = []
var current_index: int = 0

@onready var timer = $Timer


func _ready():
	create_multiple_waves()
	await get_tree().create_timer(1.0).timeout
	start_spawning()


func setup_spawn_list(spawn_list: Array):
	spawn_queue = spawn_list.duplicate()
	print("Setup spawn list with ", spawn_queue.size(), " enemies")


func start_spawning():
	if spawn_queue.is_empty():
		print("No enemies to spawn!")
		return
	spawn_next_enemy()


func spawn_next_enemy():
	if current_index >= spawn_queue.size():
		print("All enemies spawned!")
		return
	
	var spawn_data = spawn_queue[current_index]
	
	# Spawn the enemy
	var enemy_instance = spawn_data["enemy_scene"].instantiate()
	enemy_instance.position = spawn_data["spawn_position"]
	
	# Attach movement script
	if spawn_data.get("movement_script") and enemy_instance.has_node("Movement"):
		enemy_instance.get_node("Movement").set_script(spawn_data["movement_script"])
		print("Attached movement script to enemy")
	
	# Attach attack script  
	if spawn_data.get("attack_script") and enemy_instance.has_node("Attack"):
		enemy_instance.get_node("Attack").set_script(spawn_data["attack_script"])
		print("Attached attack script to enemy")
	
	get_parent().add_child(enemy_instance)
	print("Spawned enemy ", current_index + 1, " at ", spawn_data["spawn_position"])
	
	current_index += 1
	
	# Schedule next spawn
	if current_index < spawn_queue.size():
		timer.wait_time = spawn_data["delay_until_next"]
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


func create_multiple_waves():
	var basic_enemy = preload("res://scenes/enemy.tscn")
	var straight_move = load("res://scripts/straight_down_movement.gd")
	var single_shot = load("res://scripts/single_shot_attack.gd")
	
	# Wave 1: Basic enemies
	var wave1 = []
	for i in range(5):
		wave1.append(EnemySpawner.create_spawn_data(
			basic_enemy, Vector2(150 + i * 5, -50), straight_move, single_shot, 0.1))
	
	# Wave 2: Pattern enemies
	var wave2 = []
	var positions = [Vector2(200, -50), Vector2(400, -50), Vector2(600, -50)]
	for pos in positions:
		wave2.append(EnemySpawner.create_spawn_data(
			basic_enemy, pos, straight_move, single_shot, 0.5))
	
	# Start with wave 1
	setup_spawn_list(wave1)
	# After wave 1 finishes, start wave 2
	await get_tree().create_timer(5.0).timeout
	setup_spawn_list(wave2)
