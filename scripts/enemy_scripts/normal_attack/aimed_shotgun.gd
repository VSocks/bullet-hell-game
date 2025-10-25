extends Node2D

var spread_angle: float = deg_to_rad(30)

func shoot():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	
	var enemy_global_pos = get_parent().global_position
	var base_direction = (player.global_position - enemy_global_pos).normalized()
	var base_angle = base_direction.angle()
	
	var angles = [
		base_angle - (spread_angle / 2),
		base_angle,
		base_angle + (spread_angle / 2)
	]
	
	for angle in angles:
		var direction = Vector2(cos(angle), sin(angle))
		var bullet = BulletPool.get_bullet("eb_missile")
		var bullet_position = enemy_global_pos + direction
		var bullet_direction = direction
		var bullet_rotation = angle
		bullet.initialize(bullet_position, bullet_direction, 350, bullet_rotation)


func execute_attack():
	shoot()
