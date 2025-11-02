extends Node2D

var laser_count : int = 5
var can_shoot : bool = true


func shoot():
	for i in range(laser_count):
		var bullet = BulletPool.get_bullet("eb_laser")
		bullet.initialize(global_position, Vector2.DOWN, 600 - i * 20, Vector2.DOWN.angle())
