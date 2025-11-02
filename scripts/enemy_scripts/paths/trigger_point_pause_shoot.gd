extends PointTriggerFollower
class_name PauseAndShootFollower

var pause_duration: float = 1.0
var is_paused: bool = false
var pause_timer: float = 0.0
var has_shot: bool = false

func _ready():
	trigger_points = [1]  # Point index 1 triggers pause+shoot
	speed = 400.0

func _process(delta):
	if is_paused:
		pause_timer -= delta
		if pause_timer <= 0:
			is_paused = false
		return
	
	progress += speed * delta
	check_trigger_points()
	
	if progress_ratio >= 1.0:
		get_parent().queue_free()

func on_trigger_point_reached(point_index: int):
	if not has_shot:
		#print_debug("Pausing and shooting at point ", point_index)
		shoot()
		is_paused = true
		pause_timer = pause_duration
		has_shot = true

func shoot():
	var enemy = get_child(0) if get_child_count() > 0 else null
	if enemy and enemy.has_node("Attack"):
		var attack_node = enemy.get_node("Attack")
		if attack_node.has_method("shoot"):
			attack_node.shoot()
		elif attack_node.has_method("execute_attack"):
			attack_node.execute_attack()
