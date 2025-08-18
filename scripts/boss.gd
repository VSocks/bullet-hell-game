extends CharacterBody2D
class_name Boss

signal shoot1
#signal shoot2
#signal shoot4
#signal shoot5

var max_health : int = 1000
var health : int

func _ready():
	position = Vector2(570, 100)
	health = max_health

func _process(delta):
	if health >= 0.75 * max_health:
		shoot1.emit()
	#possíveis outras fases do boss
	#if 0.75 * max_health > health && health >= 0.5 * max_health:
	#	shoot2.emit()
	#if 0.5 * max_health > health && health >= 0.25 * max_health:
	#	shoot4.emit()
	#if 0.25 * max_health > health:
	#	shoot5.emit()

func take_damage(damage):
	print("boss takes damage!")
	health -= damage
	if health <= 0:
		queue_free()
