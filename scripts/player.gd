extends CharacterBody2D
class_name Player

signal shoot

var speed : int = 250
var max_health : int = 5
var health : int
var can_hit : bool

func _ready():
	$InvincibilityTimer.set_wait_time(3)
	global_position = Vector2(570, 600)
	health = max_health
	can_hit = true

func _process(delta):
	if Input.is_action_just_pressed("focus"):
		speed = 85
	elif Input.is_action_just_released("focus"):
		speed = 250
		
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		shoot.emit()

func take_damage(damage):
	if can_hit:
		print("player takes damage!")
		$InvincibilityTimer.start()
		print("player temporairly invincible!")
		health -= damage
		if health <= 0:
			queue_free()
			print("player dead!")
		can_hit = false

func _on_invincibility_timer_timeout():
	can_hit = true
	print("incinvibility over!")
