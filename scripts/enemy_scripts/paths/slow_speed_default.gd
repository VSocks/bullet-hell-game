extends PathFollow2D


func _ready():
	pass


func _process(delta):
	progress += 300 * delta
	if progress_ratio >= 1:
		get_parent().queue_free()
