extends Node2D

@onready var light: PointLight2D = $PointLight2D

@export var flicker_intensity: float = 0.2 
@export var flicker_speed: float = 2.0 
@export var base_energy: float = 0.5

func _ready() -> void:
	light.energy = base_energy


func _process(_delta: float):
	var noise = randf() * flicker_intensity - (flicker_intensity / 2.0)
	light.energy = base_energy + noise * sin(flicker_speed * Time.get_ticks_msec() / 1000.0)
