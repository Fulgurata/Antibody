extends CharacterBody2D

@onready var player = null
@export var MIN_DISTANCE: float = 200.0
@export var flare_scene = preload("res://scenes/characters/drone/flare.tscn")
@export var flare_cooldown: float = 60.0

var SPEED: int = 500
var _flare_timer: float = 0.0
var can_spawn_flare: bool = true

func _ready() -> void:
	player = get_tree().get_current_scene().find_child("Player")
	if not player:
		print("Player not found in parent node!")

func _physics_process(_delta: float) -> void:
	if _flare_timer > 0:
		_flare_timer -= _delta
	else:
		can_spawn_flare = true
	#Drone follows the player
	if is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player > MIN_DISTANCE:
			velocity = (player.global_position - global_position).normalized() * SPEED
		look_at(get_global_mouse_position())
	else:
		velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("flare") and can_spawn_flare:
		spawn_flare()
	
	move_and_slide()

func spawn_flare() -> void:
	if flare_scene == null:
		return
	var flare = flare_scene.instantiate()
	flare.position = global_position
	get_tree().get_current_scene().add_child(flare)
	can_spawn_flare = false
	_flare_timer = flare_cooldown
