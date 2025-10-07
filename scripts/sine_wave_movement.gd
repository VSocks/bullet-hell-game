extends Node2D

var speed: float = 80.0
var amplitude: float = 50.0
var frequency: float = 2.0
var time: float = 0.0
var start_x: float

func _ready():
	start_x = get_parent().position.x

func _physics_process(delta):
	time += delta
	get_parent().position.y += speed * delta
	get_parent().position.x = start_x + sin(time * frequency) * amplitude
	
	if get_parent().position.y > get_viewport_rect().size.y + 50:
		get_parent().queue_free()
