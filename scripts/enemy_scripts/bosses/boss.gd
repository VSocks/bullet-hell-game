extends CharacterBody2D
class_name Boss

const MAX_HEALTH : int = 1000

var health : int
var move_speed : float = 500.0
var is_moving : bool = false
var is_attacking: bool = false
var target_position : Vector2


@onready var attack1 = $AttackPatterns/Attack1
@onready var attack2 = $AttackPatterns/Attack2
@onready var attack3 = $AttackPatterns/Attack3
@onready var current_attack = attack1
@onready var phase_transition_timer = $PhaseTransitionTimer
@onready var hitbox = $Hitbox



func _ready():
	add_to_group("enemies")
	health = MAX_HEALTH
	phase_transition_timer.wait_time = 1
	phase_transition_timer.one_shot = true
	start_attacking()
	is_attacking = true


func _process(delta):
	if is_moving:
		# Simple linear interpolation movement
		#print("moving")
		position = position.move_toward(target_position, move_speed * delta)
		
		if position.distance_to(target_position) < 5.0:
			is_moving = false
			if is_attacking == false:
				start_attacking()
				is_attacking = true
			#print("Boss reached target")


func start_attacking():
	current_attack.start_attack()


func stop_attacking():
	current_attack.stop_attack()


func take_damage(damage):
	health -= damage
	print("boss takes damage!")
	check_phase_change()
	print(health)
	if health <= 0:
		clear_bullets()
		queue_free()


func check_phase_change():
	var health_percent = float(health) / MAX_HEALTH
	
	if health_percent < 0.5 and current_attack == attack2:
		hitbox.set_deferred("disabled", true)
		current_attack.stop_attack()
		clear_bullets()
		current_attack = attack3
		phase_transition_timer.start()
	elif health_percent < 0.75 and current_attack == attack1:
		hitbox.set_deferred("disabled", true)
		current_attack.stop_attack()
		clear_bullets()
		current_attack = attack2
		phase_transition_timer.start()


func move_to_random_position():
	var random_offset = Vector2(
		randf_range(-50, 50),
		randf_range(-50, 50)
	)
	
	target_position = position + random_offset
	target_position = clamp_to_screen_bounds(target_position)
	is_moving = true
	#print("calculatig position")


func stop_attacking_and_move():
	stop_attacking()
	is_attacking = false
	move_to_random_position()


func clamp_to_screen_bounds(pos: Vector2) -> Vector2:
	var viewport = get_viewport_rect().size
	return Vector2(
		clamp(pos.x, 100, viewport.x - 100),
		clamp(pos.y, 50, viewport.y / 3)
	)


func clear_bullets():
	var bullets = get_tree().get_nodes_in_group("enemy_bullets")
	for bullet in bullets:
		BulletPool.return_bullet(bullet)


func _on_phase_transition_timer_timeout():
	current_attack.start_attack()
	hitbox.set_deferred("disabled", false)
