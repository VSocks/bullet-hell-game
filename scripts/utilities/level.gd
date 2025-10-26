extends Node2D

func _ready():
	# Initialize the bullet pool for this level
	BulletPool.initialize_pool()
	
	# Your existing level initialization code...
	print("Level loaded and bullet pool initialized")
