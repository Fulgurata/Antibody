extends Area2D


@export var hover_time: float = 2.5  # Time to hover over the player
@export var slam_delay: float = 0.5  # Delay before the slam animation
@export var damage: int = 20  # Damage to the player

@onready var player: CharacterBody2D = $Player
var is_attacking: bool = false

signal tentacle_slammed()

func _ready():
	player = get_tree().get_current_scene().find_child("Player")
	

func start_attack():
	if is_attacking or player == null:
		return
	
	is_attacking = true
	hover_over_player()

func hover_over_player():
	if player == null:
		is_attacking = false
		return
	$Sprite2D.position = player.global_position
	await(get_tree().create_timer(hover_time)).timeout
	slam()

func slam():
	await(get_tree().create_timer(slam_delay)).timeout
	if $".".overlaps_body(player):
		player.take_damage(damage)
	emit_signal("tentacle_slammed")
	is_attacking = false
