extends Node2D

@onready var NextLevel: String = "res://scenes/levels/top_side_level/top_side_level.tscn"

# Called when the node enters the scene tree for the first time.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file(NextLevel)
