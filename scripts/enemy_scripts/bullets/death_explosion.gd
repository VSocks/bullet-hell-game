extends Area2D

const DAMAGE : int = 2

var is_initialized : bool = false
var sound = preload("res://assets/sounds/enemy_death_explosion.wav")

@onready var animation = $AnimatedSprite2D


func initialize(_position):
	position = _position
	is_initialized = true
	animation.play("explode")
	AudioManager.play_sound(sound, -10)


func _on_animation_finished():
	BulletPool.return_bullet(self)
