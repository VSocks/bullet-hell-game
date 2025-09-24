class_name Boss
extends CharacterBody2D

const MAX_HEALTH : int = 500

var health : int
var counter : int
var i : int = 1

@onready var attack1 = $AttackPatterns/Attack1
@onready var attack2 = $AttackPatterns/Attack2
@onready var attack3 = $AttackPatterns/Attack3
@onready var current_attack = attack1


func _ready():
	add_to_group("enemies")
	position = Vector2(570, 100)
	health = MAX_HEALTH
	start_attacking()


#func _process(_delta):
	#position += Vector2(1,0) * i
	#counter += 1
	#if counter >= 100:
	#	counter = 0
	#	i = -i


func start_attacking():
	current_attack.start_attack()


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
		switch_attack(attack3)
	elif health_percent < 0.75 and current_attack == attack1:
		switch_attack(attack2)
		


func switch_attack(new_pattern):
	current_attack.stop_attack()
	
	current_attack = new_pattern
	current_attack.start_attack()
	
	#print("Switched to new attack pattern!")


func stop_attacking():
	current_attack.stop_attack()
