extends Area2D

const MAX_HEALTH : int = 10

var health : int
var can_attack : bool = false

@onready var hitbox = $Hitbox


func _ready():
	hitbox.set_deferred("disabled", true)
	add_to_group("enemies")
	health = MAX_HEALTH


func take_damage(damage):
	health -= damage

	if health <= 0:
		queue_free()


func _on_screen_entered():
	can_attack = true
	hitbox.set_deferred("disabled", false)


func _on_screen_exited():
	#print("enemy freed")
	queue_free()


func _on_body_entered(_hitbox):
	if _hitbox is Player:
		_hitbox.take_damage()
