extends Node2D

@export var laser_duration: float = 1.5  # How long the laser stays active
@export var laser_length: float = 500  # Length of the laser
@export var warning_duration: float = 2.0  # Time to show a warning before firing

@onready var line2d = $Line2D

var active = false

func setup_laser(position: Vector2, rotation: float):
	# Initialize the laser's position and rotation
	self.position = position
	self.rotation = rotation
	start_laser_sequence()
	
func start_laser_sequence():
	if not line2d:
		print("Error: Line2D node not found!")
		return
	# Set the initial laser as a warning (thin or transparent line)
	line2d.width = 2  # Small width for warning
	line2d.set_points([Vector2(0, 0), Vector2(laser_length, 0)])
	await get_tree().create_timer(warning_duration).timeout
	fire_laser()
	
func fire_laser():
	# Activate the laser
	active = true
	line2d.width = 8  # Increase the width
	line2d.modulate = Color(1, 0, 0)  # Change color to red
	await get_tree().create_timer(laser_duration).timeout
	queue_free()# Remove the laser after the duration
