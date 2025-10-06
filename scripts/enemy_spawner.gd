extends Node
class_name EnemySpawner

# Define the spawn data class
class SpawnData:
	var enemy_scene: PackedScene
	var spawn_position: Vector2
	var movement_script: Script
	var attack_script: Script
	var delay_until_next: float
	
	func _init(scene: PackedScene, pos: Vector2, move_script: Script, atk_script: Script, delay: float):
		enemy_scene = scene
		spawn_position = pos
		movement_script = move_script
		attack_script = atk_script
		delay_until_next = delay

# Use Array instead of Array[SpawnData] for compatibility
var spawn_queue: Array = []
var current_index: int = 0
var is_spawning: bool = false

@onready var timer = $Timer

func _ready():
	setup_enemy_wave()

func setup_enemy_wave():
	# Preload resources
	var basic_enemy_scene = preload("res://scenes/enemy.tscn")
	
	# Preload scripts using load() instead of preload() for flexibility
	var straight_down_move = load("res://scripts/straight_down_movement.gd")
	var single_shot_attack = load("res://scripts/single_shot_attack.gd")
	
	# Create spawn list - make sure all elements are SpawnData objects
	var spawn_list = []
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy_scene, Vector2(100, 0), straight_down_move, single_shot_attack, 2.0))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy_scene, Vector2(200, 0), straight_down_move, single_shot_attack, 1.5))
	
	spawn_list.append(EnemySpawner.create_spawn_data(
		basic_enemy_scene, Vector2(300, 0), straight_down_move, single_shot_attack, 3.0))
	
	# Setup spawner
	setup_spawn_list(spawn_list)
	print("Enemy wave setup complete!")
	await get_tree().create_timer(1.0).timeout
	start_spawning()

# Accept any array type
func setup_spawn_list(spawn_list: Array):
	spawn_queue = spawn_list.duplicate()
	print("Spawn list setup with ", spawn_queue.size(), " enemies")

func start_spawning():
	if spawn_queue.is_empty():
		push_error("Spawn queue is empty!")
		return
	
	is_spawning = true
	spawn_next_enemy()

func spawn_next_enemy():
	if current_index >= spawn_queue.size():
		print("All enemies spawned!")
		is_spawning = false
		return
	
	var spawn_data = spawn_queue[current_index]
	
	# Verify it's the correct type
	if not spawn_data is SpawnData:
		push_error("Invalid spawn data at index ", current_index)
		current_index += 1
		spawn_next_enemy()
		return
	
	spawn_enemy(spawn_data)
	current_index += 1
	
	# Schedule next spawn if there are more enemies
	if current_index < spawn_queue.size():
		timer.wait_time = spawn_data.delay_until_next
		timer.start()

func spawn_enemy(spawn_data: SpawnData):
	var enemy_instance = spawn_data.enemy_scene.instantiate()
	
	# Set position
	enemy_instance.position = spawn_data.spawn_position
	
	# Attach movement script
	if spawn_data.movement_script and enemy_instance.has_node("Movement"):
		var movement_node = enemy_instance.get_node("Movement")
		movement_node.set_script(spawn_data.movement_script)
		print("Attached movement script: ", spawn_data.movement_script.resource_path.get_file())
	
	# Attach attack script
	if spawn_data.attack_script and enemy_instance.has_node("Attack"):
		var attack_node = enemy_instance.get_node("Attack")
		attack_node.set_script(spawn_data.attack_script)
		print("Attached attack script: ", spawn_data.attack_script.resource_path.get_file())
	
	# Add to scene
	get_parent().add_child(enemy_instance)
	print("Spawned enemy at position: ", spawn_data.spawn_position)

func _on_timer_timeout():
	spawn_next_enemy()

# Static function to create spawn data
static func create_spawn_data(scene: PackedScene, pos: Vector2, move_script: Script, attack_script: Script, delay: float) -> SpawnData:
	return SpawnData.new(scene, pos, move_script, attack_script, delay)
