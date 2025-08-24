extends CharacterBody2D
class_name Boss

var max_health : int = 10000
var health : int

@onready var spiral_attack = $AttackPatterns/SpiralAttack
#@onready var new_attack = $AttackPatterns/NewAttack
@onready var current_attack = spiral_attack  # Start with spiral


func _ready():
	add_to_group("enemies")
	position = Vector2(570, 100)
	health = max_health
	start_attacking()


func start_attacking():
	current_attack.start_attack()


func take_damage(damage):
	health -= damage
	#print("boss takes damage!")
	check_phase_change()
	if health <= 0:
		queue_free()


func check_phase_change():
	var _health_percent = float(health) / max_health
	
#	if health_percent < 0.25 and current_attack == spiral_attack:
#		switch_attack(new_attack)
#	elif health_percent < 0.5:
#		# You can add more patterns here later
#		pass


func switch_attack(new_pattern):
	current_attack.stop_attack()
	
	current_attack = new_pattern
	current_attack.start_attack()
	
	#print("Switched to new attack pattern!")


func stop_attacking():
	current_attack.stop_attack()
