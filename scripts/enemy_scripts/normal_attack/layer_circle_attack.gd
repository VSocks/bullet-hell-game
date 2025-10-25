extends Node2D

var layer_count: int = 5
var bullets_per_ring: int = 18


func shoot():
	for layer in range(layer_count):
		for i in range(bullets_per_ring):
			var angle = (TAU / bullets_per_ring) * i
			var direction = Vector2(cos(angle), sin(angle))
			
			var bullet = BulletPool.get_bullet("eb_round")
			bullet.initialize(global_position, direction, 100 - (layer * 5), direction.angle())
