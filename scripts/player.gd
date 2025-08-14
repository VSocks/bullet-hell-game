extends CharacterBody2D

signal shoot

var speed : int = 250
var max_health : int = 5
var health : int

func _ready():
	global_position = Vector2(570, 600)
	health = max_health

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
	print("player takes damage!")
	health -= damage
	if health <= 0:
		queue_free()
