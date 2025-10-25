extends Node2D

var can_shoot: bool = true


func shoot():
	var bullet = BulletPool.get_bullet("eb_laser")
	bullet.initialize(global_position, Vector2.DOWN, 600, Vector2.DOWN.angle())
