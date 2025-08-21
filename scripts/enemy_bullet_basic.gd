extends Area2D
class_name Bullet

var speed : int = 400
var direction = Vector2.DOWN

func _ready():
	rotation = direction.angle() + PI / 2
	# Connect signals properly
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += direction * speed * delta
	
	# Check if off-screen
	if global_position.y > get_viewport_rect().size.y + 50:
		BulletPool.return_bullet(self)

func _on_body_entered(hitbox):
	if hitbox is Player:
		hitbox.take_damage()
	BulletPool.return_bullet(self)
