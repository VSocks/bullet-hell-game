extends Area2D

var damage : int = 1
var speed : int = 1
var direction = Vector2.UP


func _ready():
	add_to_group("player_bullets")


func _process(delta):
	position += direction * speed * delta


func _on_body_entered(hitbox):
	if hitbox.is_in_group("enemies"):
		hitbox.take_damage(damage)
	queue_free()


func _on_screen_exited():
	queue_free()
