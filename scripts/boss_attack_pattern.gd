extends Node2D

var bullet_scene : PackedScene = load("res://scenes/bullet.tscn")

var angle : float = 0.0
var spiral_speed : float = 5.0
var bullet_count : int = 4


func _on_boss_shoot() -> void:
		#um possível padrão de tiro do chefão (espiral)
	#sinta-se livre para brincar com as variaveis e ver as alterações
	#o plano é ter diversos padrões de tiro que funcionam de maneiras diferentes
	#ou seja que não necessariamente seguem a mesma lógica de giro espiral
	#e o chefão alterar entre os padrões de ataque entre as fases
	#por um lado precisamos levar balanceamento em consideração
	#por outro lado a extrema dificuldade meio que é parte do gênero bullet hell
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		var direction = Vector2(cos(angle), sin(angle))
		bullet.global_position = global_position
		bullet.direction = direction
		bullet.speed = 150
		angle += 2 * PI / bullet_count
	angle += 0.25
	print("spiral shot fired!")
