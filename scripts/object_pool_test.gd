extends Node

#teste que fiz sobre object pooling de balas. não funcionou e não utilizei
#mas posso tentar novamente depois, quando entender mais a respeito
#object pooling é bem útil em bullet hell pelo que pesquisei

@export var scene : PackedScene
var object_pool : Array = []

func add_to_pool(object : Node2D) -> void:
	object_pool.append(object)
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()
	print("object added to pool")

func pull_from_pool() -> Node2D:
	var object: Node2D
	if object_pool.is_empty():
		object = scene.instantiate()
		print("object instantiated")
	else:
		object = object_pool.pop_front()
		print("object pulled from pool")
	object.set_process(true)
	object.set_physics_process(true)
	object.show()
	return object
