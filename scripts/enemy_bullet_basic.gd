extends Area2D
class_name Bullet

var speed : int = 400
var direction = Vector2.DOWN
var pool_manager : BulletPool
var borderx : float
var bordery : float


func _ready():
	borderx = get_viewport_rect().size.x + 100
	bordery = get_viewport_rect().size.y + 100
	add_to_group("enemy_bullets")


func setup(_direction: Vector2, _speed: int):
	direction = _direction
	speed = _speed
	rotation = direction.angle() + PI / 2


func _process(delta):
	position += direction * speed * delta
	#if global_position.y > bordery or global_position.x > borderx or global_position.x < -100 or global_position.y < -100:
	#	BulletPool.return_bullet(self)


func _on_body_entered(hitbox):
	if hitbox is Player:
		hitbox.take_damage()
	BulletPool.return_bullet(self)
