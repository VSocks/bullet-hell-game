extends Area2D
class_name Bullet

var speed : int = 400
var direction = Vector2.DOWN
var pool_manager : BulletPool

func _ready():
	rotation = direction.angle() + PI / 2
	add_to_group("enemy_bullets")

func _physics_process(delta):
	position += direction * speed * delta
	
	# Check if off-screen
	if global_position.y > get_viewport_rect().size.y + 50:
		return_to_pool()

func setup(_direction: Vector2, _speed: int, _pool_manager: BulletPool):
	$BulletSound.play()
	direction = _direction
	speed = _speed
	pool_manager = _pool_manager
	rotation = direction.angle() + PI / 2

func _on_body_entered(hitbox):
	if hitbox is Player:
		hitbox.take_damage()
	return_to_pool()

func return_to_pool():
	if pool_manager:
		pool_manager.return_bullet(self)
	else:
		queue_free()  # Fallback if no pool manager

func _on_screen_exited():
	return_to_pool()
