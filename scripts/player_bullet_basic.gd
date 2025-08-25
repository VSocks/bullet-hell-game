class_name PlayerBullet
extends Area2D

var damage : int = 1
var speed : int = 1
var direction : Vector2 = Vector2.DOWN


func _ready():
	add_to_group("player_bullets")


func _physics_process(delta):
	position += direction * speed * delta


func initialize(_position, _direction, _speed, _angle):
	position = _position
	direction = _direction
	speed = _speed
	rotation = _angle + PI /2
	$BulletSound.play()


func _on_body_entered(hitbox):
	if hitbox.is_in_group("enemies"):
		hitbox.take_damage(damage)
	BulletPool.return_bullet(self)


func _on_screen_exited():
	BulletPool.return_bullet(self)
