extends Area2D

const DAMAGE : int = 1

var speed : int = 800
var direction : Vector2 = Vector2.UP
var is_initialized : bool = false
var tween := self.create_tween()

var explosion_scene = preload("res://scenes/player_bullet_explosion.tscn")


func _ready():
	add_to_group("player_bullets")


func _physics_process(delta):
	if not is_initialized:
		return
	position += direction * speed * delta


func initialize(_position, _direction, _speed, _angle):
	position = _position
	direction = _direction
	speed = _speed
	rotation = _angle + PI / 2
	is_initialized = true
	reset_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.0)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	#$BulletSound.play()


func reset_bullet():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	position = Vector2(-1000, -1000)
	is_initialized = false
	direction = Vector2.UP
	speed = 800
	if $BulletSound.playing:
		$BulletSound.stop()


func reset_tween():
	if tween:
		tween.kill()
		tween = create_tween()


func _on_body_entered(hitbox):
	if not is_initialized:
		return 
	
	if hitbox.is_in_group("enemies"):
		hitbox.take_damage(DAMAGE)
		var explosion = explosion_scene.instantiate()
		explosion.position = position
		get_tree().current_scene.add_child(explosion)
		BulletPool.return_bullet(self)


func _on_screen_exited():
	if is_initialized:
		BulletPool.return_bullet(self)
