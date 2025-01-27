extends PointLight2D

@onready var light: PointLight2D = $"."


@export var flicker_intensity: float = 3 
@export var flicker_speed: float = 50.0 
@export var base_energy: float = 3.0

func _ready() -> void:
	$AnimatedSprite2D.play()
	light.energy = base_energy


func _process(_delta: float):
	var noise = randf() * flicker_intensity - (flicker_intensity / 2.0)
	light.energy = base_energy + noise * sin(flicker_speed * Time.get_ticks_msec() / 1000.0)
