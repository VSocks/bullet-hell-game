class_name Player
extends CharacterBody2D

const SLOW_SPEED : int = 80
const NORMAL_SPEED : int = 240
const ROTATION_SPEED: float = 10.0
const MAX_HEALTH : int = 5

var speed : int
var health : int
var is_focusing : bool = false
var target_rotation: float = 0.0

@onready var current_attack = $PlayerAttackLaser
@onready var invincibility_timer = $InvincibilityTimer
@onready var hitbox = $Hitbox


func _ready():
	global_position = Vector2(570, 600)
	health = MAX_HEALTH
	speed = NORMAL_SPEED


func _process(delta):
	get_input()
	handle_rotation(delta)
	move_and_slide()


func get_input():
	if Input.is_action_just_pressed("focus"):
		speed = SLOW_SPEED
	if Input.is_action_just_released("focus"):
		speed = NORMAL_SPEED
	
	if Input.is_action_just_pressed("shoot"):
		current_attack.start_attack()
	if Input.is_action_just_released("shoot"):
		current_attack.stop_attack()
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed	
	
	if direction.x != 0:
		target_rotation = deg_to_rad(30) * sign(direction.x)
	else:
		target_rotation = 0.0


func handle_rotation(delta):
	if target_rotation != 0:
		rotation = lerp_angle(rotation, target_rotation, ROTATION_SPEED * delta)
	else:
		rotation = lerp_angle(rotation, 0.0, ROTATION_SPEED * delta)


func take_damage():
	hitbox.set_deferred("disabled", true)
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
	hitbox.set_deferred("disabled", false)
	print("incinvibility over!")
