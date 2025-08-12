extends Area2D

var bullet_scene : PackedScene = load("res://scenes/bullet.tscn")


func _ready():
	position = Vector2(570, 100)
