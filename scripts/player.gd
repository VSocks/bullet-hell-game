extends CharacterBody2D
var speed : int = 250
var laser_scene : PackedScene = load("res://scenes/laser.tscn")

func _ready():
	position = Vector2(570, 600)

func _process(_delta):
	if Input.is_action_just_pressed("focus"):
		speed /= 2
	elif Input.is_action_just_released("focus"):
		speed *= 2
		
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		var laser = laser_scene.instantiate()
		get_parent().add_child(laser)
		laser.position = position
		laser.position.y -= 20
