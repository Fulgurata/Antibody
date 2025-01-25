extends Node2D
class_name Boss_State

@onready var player = owner.get_parent().find_child("Player")
@onready var ray_cast = owner.find_child("RayCast2D")
@onready var debug = owner.find_child("debug")

func _ready():
	set_physics_process(false)

func enter(): 
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass

func _physics_process(_delta):
	transition()
	if debug:
		debug.text = name  # Update the debug text with the name of the current state
	else:
		print("Error: 'debug' node not found or not properly assigned.")
