extends Node2D


var NextLevel: String = "res://scenes/levels/Level2/level_2.tscn"
@onready var fader = get_tree().get_current_scene().find_child("Fade_Transition")
@onready var faderanim = get_tree().get_current_scene().find_child("AnimationPlayer")
@onready var fadetimer = get_tree().get_current_scene().find_child("EndLevelTimer")


func _on_end_level_timer_timeout() -> void:
	print("congrats, next level")
	get_tree().change_scene_to_file(NextLevel)
	

func _on_transition_area_area_entered(_area: Area2D) -> void:
	var current_path: String = get_tree().get_current_scene().scene_file_path
	GameState.last_scene_path = current_path
	fader.show()
	faderanim.play("fade_out")
	fadetimer.start()
