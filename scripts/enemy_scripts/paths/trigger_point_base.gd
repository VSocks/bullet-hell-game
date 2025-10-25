extends PathFollow2D
class_name PointTriggerFollower

var speed: float = 500.0
var trigger_points: Array = []  # Array of point indices to trigger at
var triggered_points: Array = []  # Track which points we've already triggered

func _ready():
	# Override this in child classes to set trigger points
	pass

func _process(delta):
	progress += speed * delta
	
	# Check for trigger points
	check_trigger_points()
	
	if progress_ratio >= 1.0:
		get_parent().queue_free()

func check_trigger_points():
	for point_index in trigger_points:
		if point_index in triggered_points:
			continue  # Already triggered this point
		
		var point_position = get_parent().curve.get_point_position(point_index)
		var current_position = get_parent().curve.sample_baked(progress)
		
		# Check if we're close enough to the trigger point
		if current_position.distance_to(point_position) < 5.0:
			on_trigger_point_reached(point_index)
			triggered_points.append(point_index)

func on_trigger_point_reached(point_index: int):
	# Override this in child classes
	pass
