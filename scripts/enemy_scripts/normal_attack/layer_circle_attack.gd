extends Node2D

var layer_count: int = 9
var bullets_per_ring: int = 18


func shoot():
	var increment = 0
	for layer in range(layer_count):
		increment += 0.1
		for i in range(bullets_per_ring):
			var angle = (TAU / bullets_per_ring) * i + increment
			var direction = Vector2(cos(angle), sin(angle))
			
			var bullet = BulletPool.get_bullet("eb_square")
			bullet.initialize(global_position, direction, 150 - (layer * 5), direction.angle())
