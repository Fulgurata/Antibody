extends CharacterBody2D

@onready var player: Node2D = null
var SPEED: int = 200
@export var pop_distance: float = 0.5

func _ready():
	player = get_tree().get_current_scene().find_child("Player")
	if not player:
		print("Player not found in parent node!")
		

func _physics_process(_delta: float) -> void:
	$AnimatedSprite2D.play()
	if is_instance_valid(player):
		velocity = (player.global_position - global_position).normalized() * SPEED
		look_at(player.global_position)
	else:
		print("player not found")
		velocity = Vector2.ZERO
	var collision = move_and_collide(velocity * _delta)
	if collision:
		queue_free()
