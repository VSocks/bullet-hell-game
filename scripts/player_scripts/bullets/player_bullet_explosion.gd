extends Area2D

const DAMAGE : int = 2

@onready var hitbox_sprite = $Hitbox
@onready var timer = $Timer


func _ready():
	timer.wait_time = 0.25
	timer.start()


func _on_body_entered(hitbox):
	if hitbox.is_in_group("enemies"):
		hitbox.take_damage(DAMAGE)
		hitbox.set_deferred("disabled", true)


func _on_timer_timeout():
	queue_free()
