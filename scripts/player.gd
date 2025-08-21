extends CharacterBody2D
class_name Player

var speed : int = 240
var max_health : int = 5
var health : int

@onready var current_attack = $PlayerAttackLaser
@onready var invincibility_timer = $InvincibilityTimer


func _ready():
	global_position = Vector2(570, 600)
	health = max_health


func _process(delta):
	if Input.is_action_just_pressed("focus"):
		speed = 80
	elif Input.is_action_just_released("focus"):
		speed = 240
	
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	
	if Input.is_action_just_pressed("shoot"):
		current_attack.start_attack()
	elif Input.is_action_just_released("shoot"):
		current_attack.stop_attack()


func take_damage():
	$Hitbox.set_deferred("disabled", true)
	print("player temporairly invincible!")
	invincibility_timer.set_one_shot(true)
	invincibility_timer.set_wait_time(3)
	invincibility_timer.start()
	health -= 1
	print("player takes damage!")
	if health <= 0:
		queue_free()
		print("player dead!")


func _on_invincibility_timer_timeout():
	$Hitbox.set_deferred("disabled", false)
	print("incinvibility over!")
