extends Area2D

const DAMAGE : int = 2

var is_initialized : bool = false

@onready var hitbox_sprite = $Hitbox
@onready var timer = $Timer


func _ready():
	timer.wait_time = 0.5


func initialize(_position):
	position = _position
	is_initialized = true
	timer.start()


func _on_body_entered(hitbox):
	if not is_initialized:
		return
	
	if hitbox.is_in_group("enemies"):
		hitbox.take_damage(DAMAGE)


func _on_timer_timeout():
	timer.stop()
	BulletPool.return_bullet(self)
