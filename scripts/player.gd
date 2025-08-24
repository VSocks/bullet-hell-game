extends CharacterBody2D
class_name Player

const SLOW_SPEED : int = 80
const NORMAL_SPEED : int = 240

var speed : int
var max_health : int = 5
var health : int

@onready var current_attack = $PlayerAttackLaser
@onready var invincibility_timer = $InvincibilityTimer
@onready var hitbox = $Hitbox


func _ready():
	global_position = Vector2(570, 600)
	health = max_health
	speed = NORMAL_SPEED


func _process(_delta):
	get_input()
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
	
	var rotation_direction = Input.get_axis("move_left", "move_right")
	rotation = rotation_direction * deg_to_rad(30)
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed


func take_damage():
	hitbox.set_deferred("disabled", true)
	#print("player temporairly invincible!")
	invincibility_timer.set_one_shot(true)
	invincibility_timer.set_wait_time(3)
	invincibility_timer.start()
	health -= 1
	#print("player takes damage!")
	if health <= 0:
		queue_free()
		#print("player dead!")


func _on_invincibility_timer_timeout():
	hitbox.set_deferred("disabled", false)
	#print("incinvibility over!")
