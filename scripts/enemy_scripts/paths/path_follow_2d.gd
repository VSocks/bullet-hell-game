extends PathFollow2D


func _ready():
	pass


func _process(_delta):
	progress += 5
	if progress_ratio >= 1:
		queue_free()
