extends CharacterBody2D

signal shoot

var speed : int = 250

func _ready():
	global_position = Vector2(570, 600)

func _process(delta):
	if Input.is_action_just_pressed("focus"):
		speed /= 2
	elif Input.is_action_just_released("focus"):
		speed *= 2
		
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		print("shoot player laser signal emmitted")
		shoot.emit()
