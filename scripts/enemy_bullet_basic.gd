extends Area2D
class_name Bullet

var speed : int = 1
var direction = Vector2.DOWN
var borderx : int
var bordery : int


func _ready():
	rotation = direction.angle() + PI / 2
	borderx = 1000
	bordery = 1000
	play_sound()


func _process(delta):
	position += direction * speed * delta


func play_sound():
	$BulletSound.play()


func _on_body_entered(hitbox):
	if hitbox is Player:
		hitbox.take_damage()
	BulletPool.return_bullet(self)


func _on_screen_exited():
	BulletPool.return_bullet(self)
