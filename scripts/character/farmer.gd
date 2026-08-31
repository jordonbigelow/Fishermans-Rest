extends CharacterBody2D

enum State{ IDLE, WALKING, FISHING }
enum FishingState { IDLE, CASTING, WAITING, CAUGHT }

@export var speed: float = 75.0 # pixel per inch

@onready var animation_player := $AnimationPlayer

var current_state = State.IDLE
var current_fishing_state: FishingState
var player_can_fish: bool = false

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction.x < 0:
		animation_player.play("walking/left")
		current_state = State.WALKING
	elif input_direction.x > 0:
		animation_player.play("walking/right")
		current_state = State.WALKING
	elif input_direction.y < 0:
		animation_player.play("walking/up")
		current_state = State.WALKING
	elif input_direction.y > 0:
		animation_player.play("walking/down")
		current_state = State.WALKING
	else:
		animation_player.play("idle/default_down")
		current_state = State.IDLE

	velocity = input_direction * speed

	if Input.is_action_just_pressed("interact") and player_can_fish and current_state != State.FISHING:
		current_state = State.FISHING
		change_fishing_state(FishingState.CASTING)


func _physics_process(_delta):
	get_input()
	move_and_slide()


func _on_non_fishing_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		print("cannot fish")
		player_can_fish = false


func _on_non_fishing_area_2d_body_exited(body: Node2D) -> void:
	if body == self:
		print("can fish")
		player_can_fish = true


func change_fishing_state(new_state: FishingState) -> void:
	current_state = new_state
	print("State: ", FishingState.keys()[new_state])
	
	match new_state:
		FishingState.IDLE:
			pass
		FishingState.CASTING:
			change_fishing_state(FishingState.WAITING)
		FishingState.WAITING:
			pass
		FishingState.CAUGHT:
			pass
