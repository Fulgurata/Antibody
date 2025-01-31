extends Node2D

@onready var NextLevel: String = "res://scenes/menus/main_menu/main_menu.tscn"
var waitflag: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and waitflag:
		get_tree().change_scene_to_file(NextLevel)


func _on_timer_timeout() -> void:
	waitflag = true
