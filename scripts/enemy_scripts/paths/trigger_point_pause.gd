extends PointTriggerFollower
class_name PauseAtPointFollower

var pause_duration: float = 1.0
var is_paused: bool = false
var pause_timer: float = 0.0

func _ready():
	# Set which point indices should trigger pauses
	trigger_points = [1]  # Point index 1 (second point) triggers pause
	speed = 500.0

func _process(delta):
	if is_paused:
		pause_timer -= delta
		if pause_timer <= 0:
			is_paused = false
		return
	
	progress += speed * delta
	check_trigger_points()
	
	if progress_ratio >= 1.0:
		get_parent().queue_free()

func on_trigger_point_reached(point_index: int):
	print("Pausing at point ", point_index)
	is_paused = true
	pause_timer = pause_duration
