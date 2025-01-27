extends Node2D


@onready var light: PointLight2D = $PointLight2D
@onready var ambience: AudioStreamPlayer = $Ambience

@export var flash_energy: float = 5.0
@export var flash_duration: float = 0.7
@export var base_energy: float = 0.1
@export var min_time_between_flashes: float = 15.0
@export var max_time_between_flashes: float = 45.0

var flash_timer: float = 0.0
var is_flashing: bool = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	light.energy = base_energy
	reset_flash_timer()
	if ambience.stream:
		ambience.stream.loop = true
		ambience.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_flashing:
		flash_timer -= delta
		if flash_timer <=0:
			end_flash()
	else:
		flash_timer -= delta 
		if flash_timer < 0:
			start_flash()

func start_flash() -> void:
	is_flashing = true
	light.energy = flash_energy
	flash_timer = flash_duration

func end_flash() -> void:
	is_flashing = false
	light.energy = base_energy
	reset_flash_timer()

func reset_flash_timer() -> void:
	flash_timer = randf_range(min_time_between_flashes, max_time_between_flashes)

func _on_fade_timer_timeout() -> void:
	print("you died menu incoming")
	get_tree().change_scene_to_file("res://scenes/menus/you_died/you_died.tscn")
