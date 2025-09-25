class_name EnemyBullet
extends Area2D

var speed : int = 300
var direction : Vector2 = Vector2.DOWN
var tragectory : String
var curve_angle : float
var deacceleration : int
var thresehold : int
var bounce_speed : int
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
		"bounce":
			move_bouncing(delta)
		_:
			move_straight(delta)


func move_straight(delta):
	position += direction * speed * delta


func move_curved(delta):
	rotation += deg_to_rad(curve_angle)
	position += transform.y.normalized() * speed * delta


func move_bouncing(delta):
	position += direction * speed * delta
	speed -= deacceleration
	if speed <= thresehold:
		speed = bounce_speed


func define_tragectory(_tragectory):
	tragectory = _tragectory


func define_curve(_curve_angle):
	curve_angle = _curve_angle


func define_bounce(_deacceleration, _thresehold, _bounce_speed):
	deacceleration = _deacceleration
	thresehold = _thresehold
	bounce_speed = _bounce_speed


func initialize(_position, _direction, _speed, _angle):
	position = _position
	direction = _direction
	speed = _speed
	rotation = _angle + PI / 2
	is_initialized = true
	reset_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.0)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.25)
	#$BulletSound.play()


func scale_bullet(_size, _time):
	#tween.tween_property(self, "scale", Vector2(0, 0), 0)
	tween.tween_property(self, "scale", Vector2(_size, _size), _time)


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
