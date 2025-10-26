extends Node2D

func _ready():
	BulletPool.initialize_pool()
	
	#print_debug("Level loaded and bullet pool initialized")
