extends Node2D

enum State { BUMBLING, SEEKING, POLINATING, RETURNING }

var bee = preload("res://scenes/bee.tscn")
@onready var bee_spawn = $Plants/BeeSpawnPoint

func _ready() -> void:
	var instance = bee.instantiate()
	bee_spawn.add_child(instance)
