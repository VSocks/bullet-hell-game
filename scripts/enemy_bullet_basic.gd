extends Area2D
class_name Bullet

var speed : int = 1
var direction = Vector2.DOWN
var borderx : int
var bordery : int


func _ready():
	add_to_group("enemy_bullets")


func _process(delta):
	position += direction * speed * delta


func initialize(_position, _direction, _speed, _angle):
	add_to_group("enemy_bullets")
	position = _position
	direction = _direction
	speed = _speed
	rotation = _angle + PI /2
	$BulletSound.play()

func _on_body_entered(hitbox):
	if hitbox is Player:
		hitbox.take_damage()
	remove_from_group("enemy_bullets")
	BulletPool.return_bullet(self)


func _on_screen_exited():
	remove_from_group("enemy_bullets")
	BulletPool.return_bullet(self)
