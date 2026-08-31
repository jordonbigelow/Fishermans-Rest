extends CharacterBody2D

enum State{ IDLE, WALKING, FISHING }
enum FishingState { IDLE, CASTING, WAITING, CAUGHT }
enum Facing {LEFT, RIGHT, UP, DOWN }

@export var speed: float = 75.0 # pixel per inch

@onready var animation_player := $AnimationPlayer

var current_state = State.IDLE
var player_facing = Facing.DOWN
var current_fishing_state: FishingState
var player_can_fish: bool = false

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	match input_direction:
		Vector2.LEFT:
			animation_player.play("walking/left")
			current_state = State.WALKING
			player_facing = Facing.LEFT
		Vector2.RIGHT:
			animation_player.play("walking/right")
			current_state = State.WALKING
			player_facing = Facing.RIGHT
		Vector2.UP:
			animation_player.play("walking/up")
			current_state = State.WALKING
			player_facing = Facing.UP
		Vector2.DOWN:
			animation_player.play("walking/down")
			current_state = State.WALKING
			player_facing = Facing.DOWN
		Vector2.ZERO:
			match player_facing:
				Facing.LEFT:
					animation_player.play("idle/default_left")
				Facing.RIGHT:
					animation_player.play("idle/default_right")
				Facing.UP:
					animation_player.play("idle/default_up")
				Facing.DOWN:
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
		player_can_fish = false


func _on_non_fishing_area_2d_body_exited(body: Node2D) -> void:
	if body == self:
		player_can_fish = true


func change_fishing_state(new_state: FishingState) -> void:
	current_state = new_state
	print("State: ", FishingState.keys()[new_state])
	
	match new_state:
		FishingState.IDLE:
			pass
		FishingState.CASTING:
			match player_facing:
				Facing.LEFT:
					animation_player.play("fishing/casting_left")
				Facing.RIGHT:
					animation_player.play("fishing/casting_right")
				Facing.UP:
					animation_player.play("fishing/casting_up")
				Facing.DOWN:
					animation_player.play("fishing/casting_down")
		FishingState.WAITING:
			pass
		FishingState.CAUGHT:
			pass
