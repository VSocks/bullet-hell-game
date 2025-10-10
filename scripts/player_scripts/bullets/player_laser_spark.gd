extends Area2D

var is_initialized : bool = false

@onready var animation = $Sprite2D


func initialize(_position):
	position = _position
	is_initialized = true
	animation.play("spark")


func _on_animation_finished():
	BulletPool.return_bullet(self)
