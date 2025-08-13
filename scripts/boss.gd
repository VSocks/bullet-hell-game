extends Area2D

signal shoot

func _ready():
	position = Vector2(570, 100)

func _process(delta):
	#apenas atira a cada frame. depois vou alterar para ter timer e para o
	#chefão se mover um pouco de vez em quando
	shoot.emit()
	print("shoot enemy bullet signal emitted")
