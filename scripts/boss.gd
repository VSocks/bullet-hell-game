class_name Boss
extends CharacterBody2D

const MAX_HEALTH : int = 500

var health : int
var counter : int
var i : int = 1

@onready var attack1 = $AttackPatterns/Attack1
@onready var attack2 = $AttackPatterns/Attack2
@onready var attack3 = $AttackPatterns/Attack3
@onready var current_attack = attack3
@onready var phase_transition_timer = $PhaseTransitionTimer
@onready var hitbox = $Hitbox



func _ready():
	add_to_group("enemies")
	position = Vector2(570, 100)
	health = MAX_HEALTH
	phase_transition_timer.wait_time = 1
	phase_transition_timer.one_shot = true
	start_attacking()


#func _process(_delta):
	#position += Vector2(1,0) * i
	#counter += 1
	#if counter >= 100:
	#	counter = 0
	#	i = -i


func start_attacking():
	current_attack.start_attack()


func stop_attacking():
	current_attack.stop_attack()


func take_damage(damage):
	health -= damage
	#print("boss takes damage!")
	check_phase_change()
	print(health)
	if health <= 0:
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


func clear_bullets():
	var bullets = get_tree().get_nodes_in_group("enemy_bullets")
	for bullet in bullets:
		BulletPool.return_bullet(bullet)


func _on_phase_transition_timer_timeout():
	current_attack.start_attack()
	hitbox.set_deferred("disabled", false)
