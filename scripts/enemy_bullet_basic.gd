extends Area2D
class_name Bullet

var speed : int = 400
var direction = Vector2.DOWN
var pool_manager : BulletPool
var is_active : bool = false
var borderx : float
var bordery : float

func _ready():
	borderx = get_viewport_rect().size.x + 100
	bordery = get_viewport_rect().size.y + 100
	rotation = direction.angle()
	add_to_group("enemy_bullets")

func __process(delta):
	if not is_active:
			return
	position += direction * speed * delta

	if global_position.y > bordery or global_position.x > borderx or global_position.x < -100 or global_position.y < -100:
		return_to_pool()

func setup(_direction: Vector2, _speed: int, _pool_manager: BulletPool):
	direction = _direction
	speed = _speed
	pool_manager = _pool_manager
	rotation = direction.angle() + PI / 2
	is_active = true
	# Re-enable processing and collision
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true

func _on_body_entered(hitbox):
	if is_active and hitbox is Player:
		hitbox.take_damage()
	return_to_pool()

func return_to_pool():
	if not is_active:
		return
	
	is_active = false
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	
	if pool_manager:
		pool_manager.return_bullet(self)
	else:
		queue_free()
