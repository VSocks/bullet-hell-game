extends Node2D

var fire_rate: float = 0.75
var can_shoot: bool = true

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = fire_rate
	timer.start()

func _on_timer_timeout():
	if can_shoot:
		shoot()

func shoot():
	if get_parent().global_position.y >= get_viewport_rect().size.y / 3:
		can_shoot = false
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	
	var enemy_global_pos = get_parent().global_position
	var bullet_direction = (player.global_position - enemy_global_pos).normalized()
	var bullet_position = enemy_global_pos + bullet_direction  # Offset slightly forward
	var bullet_rotation = bullet_direction.angle()
	var bullet = BulletPool.get_bullet("eb_diamond")
	bullet.initialize(bullet_position, bullet_direction, 350, bullet_rotation)
	#print_debug("Fired aimed shot at player!")

func execute_attack():
	shoot()
