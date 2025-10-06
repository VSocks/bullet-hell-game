extends CharacterBody2D

const MAX_HEALTH : int = 10

var health : int

@onready var hitbox = $Hitbox


func _ready():
	add_to_group("enemies")
	health = MAX_HEALTH


func take_damage(damage):
	health -= damage

	print(health)
	if health <= 0:
		queue_free()
