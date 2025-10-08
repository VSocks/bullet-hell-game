extends Node2D

var wave_speed: float = 80.0
var charge_speed: float = 300.0
var wave_amplitude: float = 60.0
var wave_duration: float = 2.0
var time: float = 0.0
var state: String = "waving"
var start_x: float
var charge_direction: Vector2

func _ready():
	start_x = get_parent().position.x
	state = "waving"

func _physics_process(delta):
	time += delta
	
	match state:
		"waving":
			get_parent().position.x = start_x + sin(time * 3.0) * wave_amplitude
			get_parent().position.y += wave_speed * delta
			
			if time >= wave_duration:
				state = "charging"
				# Charge toward player if available
				var player = get_tree().get_first_node_in_group("player")
				if player:
					charge_direction = (player.position - get_parent().position).normalized()
				else:
					charge_direction = Vector2(0, 1)  # Downward as fallback
				print("Wave complete, charging toward player!")
		
		"charging":
			get_parent().position += charge_direction * charge_speed * delta
	
	if get_parent().position.y > get_viewport_rect().size.y + 50:
		get_parent().queue_free()
