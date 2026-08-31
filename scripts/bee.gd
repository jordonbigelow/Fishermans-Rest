extends CharacterBody2D

var speed: float = 20.0

func _physics_process(_delta: float) -> void:
	velocity.x = speed * -1
	move_and_slide()
