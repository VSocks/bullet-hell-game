extends PathFollow2D


func _ready():
	pass


func _process(_delta):
	progress += 3
	if progress_ratio >= 1:
		get_parent().queue_free()
