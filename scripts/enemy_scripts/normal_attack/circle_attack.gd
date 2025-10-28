extends Node2D

var bullet_count: int = 18

@onready var enemy = get_parent()


func shoot():
	for i in range(bullet_count):
		var angle = (TAU / bullet_count) * i
		var direction = Vector2(cos(angle), sin(angle))
		
		var bullet = BulletPool.get_bullet("eb_round")
		bullet.initialize(global_position, direction, 250, direction.angle())
