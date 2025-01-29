extends Node2D

@onready var light: PointLight2D = $PointLight2D

@export var flicker_intensity: float = 0.2 
@export var flicker_speed: float = 2.0 
@export var base_energy: float = 0.5

@export var axis: Vector2 = Vector2(1, 0) # Movement direction (1,0) for horizontal, (0,1) for vertical
@export var distance: float = 100.0 
@export var speed: float = 2.0  

var start_position: Vector2
var time: float = 0.0 

var tween: Tween

func _ready() -> void:
	light.energy = base_energy
	start_position = position

func _process(delta: float):
	var noise = randf() * flicker_intensity - (flicker_intensity / 2.0)
	light.energy = base_energy + noise * sin(flicker_speed * Time.get_ticks_msec() / 1000.0)
	time += delta * speed
	position = start_position + axis * sin(time) * distance
