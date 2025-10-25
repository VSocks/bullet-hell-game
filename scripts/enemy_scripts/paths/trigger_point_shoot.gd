extends PointTriggerFollower
class_name ShootAtPointFollower

var shot_fired: bool = false

func _ready():
	trigger_points = [1]  # Point index 1 triggers shooting
	speed = 500.0

func on_trigger_point_reached(point_index: int):
	if not shot_fired:
		shoot()
		shot_fired = true

func shoot():
	# Get the enemy node (child of this PathFollow2D)
	var enemy = get_child(0) if get_child_count() > 0 else null
	if enemy and enemy.has_node("Attack"):
		var attack_node = enemy.get_node("Attack")
		if attack_node.has_method("shoot"):
			attack_node.shoot()
		elif attack_node.has_method("execute_attack"):
			attack_node.execute_attack()
	print("Fired shot at point!")
