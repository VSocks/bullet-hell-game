extends Node
class_name EnemySpawner

# Define a spawn data structure
class SpawnData:
	var enemy_scene: PackedScene
	var spawn_position: Vector2
	var movement_script: Script
	var attack_script: Script
	var delay_until_next: float
	
	func _init(scene: PackedScene, pos: Vector2, move_script: Script, attack_script: Script, delay: float):
		self.enemy_scene = scene
		self.spawn_position = pos
		self.movement_script = move_script
		self.attack_script = attack_script
		self.delay_until_next = delay

# List of enemies to spawn
var spawn_queue: Array[SpawnData] = []
var current_index: int = 0
var is_spawning: bool = false

@onready var timer = $Timer

func _ready():
	# Start spawning after a brief delay
	await get_tree().create_timer(1.0).timeout
	start_spawning()

# Add enemies to the spawn queue
func setup_spawn_list(spawn_list: Array[SpawnData]):
	spawn_queue = spawn_list.duplicate()

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
		enemy_instance.get_node("Movement").set_script(spawn_data.movement_script)
	
	# Attach attack script
	if spawn_data.attack_script and enemy_instance.has_node("Attack"):
		enemy_instance.get_node("Attack").set_script(spawn_data.attack_script)
	
	# Add to scene
	get_parent().add_child(enemy_instance)
	print("Spawned enemy at position: ", spawn_data.spawn_position)

func _on_timer_timeout():
	spawn_next_enemy()

# Utility function to quickly create spawn data
static func create_spawn_data(scene: PackedScene, pos: Vector2, move_script: Script, attack_script: Script, delay: float) -> SpawnData:
	return SpawnData.new(scene, pos, move_script, attack_script, delay)
