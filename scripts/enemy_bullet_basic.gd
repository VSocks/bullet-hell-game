class_name EnemyBullet
extends Area2D

var speed : int = 300
var direction : Vector2 = Vector2.DOWN
var tragectory : String
var curve_angle : float
var is_initialized : bool = false
var tween := self.create_tween()


func _ready():
	add_to_group("enemy_bullets")


func _physics_process(delta):
	if not is_initialized:
		return
	match tragectory:
		"straight":
			move_straight(delta)
		"curved":
			move_curved(delta)
		_:
			move_straight(delta)


func move_straight(delta):
	position += direction * speed * delta


func move_curved(delta):
	rotation += deg_to_rad(curve_angle)
	position += transform.y.normalized() * speed * delta


func define_tragectory(_tragectory, _tragectory_angle):
	tragectory = _tragectory
	curve_angle = _tragectory_angle


func initialize(_position, _direction, _speed, _angle):
	position = _position
	direction = _direction
	speed = _speed
	rotation = _angle + PI / 2
	is_initialized = true
	reset_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.0)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.25)
	$BulletSound.play()


func reset_bullet():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	position = Vector2(-1000, -1000)
	is_initialized = false
	direction = Vector2.DOWN
	speed = 300
	if $BulletSound.playing:
		$BulletSound.stop()


func reset_tween():
	if tween:
		tween.kill()
		tween = create_tween()


func _on_body_entered(hitbox):
	if not is_initialized:
		return 
	
	if hitbox is Player:
		hitbox.take_damage()
	BulletPool.return_bullet(self)


func _on_screen_exited():
	if is_initialized:
		BulletPool.return_bullet(self)
