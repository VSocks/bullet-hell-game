class_name Player
extends CharacterBody2D

const SLOW_SPEED : int = 80
const NORMAL_SPEED : int = 240
const ROTATION_SPEED: float = 10.0
const MAX_HEALTH : int = 50

var speed : int
var health : int
var is_focusing : bool = false
var can_take_damage : bool = true
var target_rotation: float = 0.0
var tween := self.create_tween()

@onready var animation = $Animation
@onready var laser_attack = $PlayerAttackLaser
@onready var explosive_attack = $PlayerAttackExplosive
@onready var current_attack = $PlayerAttackLaser
@onready var invincibility_timer = $InvincibilityTimer
@onready var hitbox = $Hitbox
@onready var hitbox_sprite = $Hitbox/HitboxSprite


func _ready():
	animation.play("default")
	health = MAX_HEALTH
	speed = NORMAL_SPEED


func _process(delta):
	get_movement(delta)
	move_and_slide()


func get_movement(delta):
	if Input.is_action_just_pressed("focus"):
		current_attack.stop_attack()
		current_attack = explosive_attack
		if Input.is_action_pressed("shoot"):
			current_attack.start_attack()
		speed = SLOW_SPEED
		hitbox_sprite.show()
	if Input.is_action_just_released("focus"):
		current_attack.stop_attack()
		current_attack = laser_attack
		if Input.is_action_pressed("shoot"):
			current_attack.start_attack()
		speed = NORMAL_SPEED
		hitbox_sprite.hide()
		
	
	if Input.is_action_just_pressed("shoot"):
		current_attack.start_attack()
	if Input.is_action_just_released("shoot"):
		current_attack.stop_attack()
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed	
	target_rotation = deg_to_rad(20) * sign(direction.x)
	rotation = lerp_angle(rotation, target_rotation, ROTATION_SPEED * delta)


func take_damage():
	if can_take_damage:
		can_take_damage = false
		print("player temporairly invincible!")
		invincibility_timer.set_one_shot(true)
		invincibility_timer.set_wait_time(3)
		invincibility_timer.start()
		health -= 1
		print("player takes damage!")
		if health <= 0:
			queue_free()
			print("player dead!")
		reset_position()


func reset_position():
	reset_tween()
	tween.tween_property(self, "position", Vector2(225, 550), 0.25)


func reset_tween():
	if tween:
		tween.kill()
		tween = create_tween()


func _on_invincibility_timer_timeout():
	can_take_damage = true
	print("incinvibility over!")
