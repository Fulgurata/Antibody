extends CharacterBody2D

@onready var player = null
@export var MIN_DISTANCE: float = 200.0

var SPEED: int = 300

func _ready() -> void:
	player = get_tree().get_current_scene().find_child("Player")
	if not player:
		print("Player not found in parent node!")

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player > MIN_DISTANCE:
			velocity = (player.global_position - global_position).normalized() * SPEED
		look_at(get_global_mouse_position())
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
