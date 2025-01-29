extends Node2D

@onready var light: PointLight2D = $PointLight2D

@export var flicker_intensity: float = 0.2 
@export var flicker_speed: float = 2.0 
@export var base_energy: float = 0.5

@export var radius: float = 200.0
@export var speed: float = 1.0  # Time to complete one circle

var tween: Tween

func _ready() -> void:
	light.energy = base_energy
	tween = get_tree().create_tween()
	tween.set_loops()  # Loop infinitely
	tween.tween_method(_update_position, 0.0, TAU, speed)  # TAU = 2 * PI

func _process(_delta: float):
	var noise = randf() * flicker_intensity - (flicker_intensity / 2.0)
	light.energy = base_energy + noise * sin(flicker_speed * Time.get_ticks_msec() / 1000.0)

func _update_position(angle: float) -> void:
	position.x = cos(angle) * radius
	position.y = sin(angle) * radius
