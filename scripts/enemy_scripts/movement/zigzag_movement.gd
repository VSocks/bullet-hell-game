extends Node2D

var speed: float = 50.0
var zigzag_speed: float = 2.0
var zigzag_amplitude: float = 100.0
var time: float = 0.0
var start_x: float

func _ready():
	start_x = get_parent().position.x

func _physics_process(delta):
	time += delta
	
	# Sawtooth pattern for sharp zigzags
	var zigzag = abs(fmod(time * zigzag_speed, 2.0) - 1.0) * 2.0 - 1.0
	
	get_parent().position.x = start_x + zigzag * zigzag_amplitude
	get_parent().position.y += speed * delta
	
	if get_parent().position.y > get_viewport_rect().size.y + 50:
		get_parent().queue_free()
