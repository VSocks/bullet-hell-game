extends Node

var bullet_scenes : Dictionary = {
	"eb_diamond": preload("res://scenes/enemy_bullet_diamond.tscn"),
	"eb_laser": preload("res://scenes/enemy_bullet_laser.tscn"),
	"eb_missile": preload("res://scenes/enemy_bullet_missile.tscn"),
	"eb_round": preload("res://scenes/enemy_bullet_round.tscn"),
	"eb_round_big": preload("res://scenes/enemy_bullet_round_big.tscn"),
	"eb_square": preload("res://scenes/enemy_bullet_square.tscn"),
	"pb_laser": preload("res://scenes/player_bullet_laser.tscn"),
}

const pool_size : int = 500

var available_bullets : Dictionary = {}
var this_level : Node


func _ready():
	this_level = get_tree().current_scene
	
	for bullet_type in bullet_scenes.keys():
		available_bullets[bullet_type] = []
		for i in range(pool_size):
			var bullet = create_bullet(bullet_type)
			available_bullets[bullet_type].append(bullet)
	
	print("Bullet pool initialized with types: ", bullet_scenes.keys())


func create_bullet(bullet_type: String) -> Area2D:
	var bullet_scene = bullet_scenes.get(bullet_type)
	if not bullet_scene:
		print("Bullet type not found: " + bullet_type)
		return null
	
	var bullet = bullet_scene.instantiate()
	bullet.visible = false
	bullet.process_mode = Node.PROCESS_MODE_DISABLED
	
	bullet.set_meta("bullet_type", bullet_type)
	
	if this_level:
		this_level.add_child(bullet)
	else:
		add_child(bullet) # Fallback
	
	return bullet


func get_bullet(bullet_type: String) -> Area2D:
	if not bullet_scenes.has(bullet_type):
		print("Unknown bullet type: " + bullet_type)
		bullet_type = "eb_round"  # Fallback
	
	var bullet_array = available_bullets.get(bullet_type, [])
	var bullet : Area2D
	
	if bullet_array.is_empty():
		bullet = create_bullet(bullet_type)
		print("Pool expanded for type: ", bullet_type)
	else:
		bullet = bullet_array.pop_back()
	
	bullet.visible = true
	bullet.process_mode = Node.PROCESS_MODE_INHERIT
	return bullet


func return_bullet(bullet: Area2D) -> void:
	call_deferred("_deferred_return_bullet", bullet)


func _deferred_return_bullet(bullet: Area2D):
	var bullet_type = bullet.get_meta("bullet_type", "diamond")
	
	if bullet.has_method("reset_bullet"):
		bullet.reset_bullet()
	else:
		bullet.visible = false
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		bullet.position = Vector2(-1000, -1000)
	
	if available_bullets.has(bullet_type):
		available_bullets[bullet_type].append(bullet)
	else:
		bullet.queue_free()
