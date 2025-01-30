extends Node2D


var NextLevel: String = ""
@onready var fader = get_tree().get_current_scene().find_child("Fade_Transition")
@onready var faderanim = get_tree().get_current_scene().find_child("AnimationPlayer")
@onready var fadetimer = get_tree().get_current_scene().find_child("EndLevelTimer")
@onready var current_path = get_tree().get_current_scene().scene_file_path


func _on_end_level_timer_timeout() -> void:
	if current_path == "res://scenes/levels/top_side_level/top_side_level.tscn":
		NextLevel = "res://scenes/levels/Level2/level_2.tscn"
	elif current_path == "res://scenes/levels/Level2/level_2.tscn":
		NextLevel = "res://scenes/levels/level_4/level_4.tscn"
	elif current_path == "res://scenes/levels/level_4/level_4.tscn":
		pass
	print("congrats, next level")
	get_tree().change_scene_to_file(NextLevel)
	print(NextLevel)
	

func _on_transition_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		current_path = get_tree().get_current_scene().scene_file_path
		GameState.last_scene_path = current_path
		fader.show()
		faderanim.play("fade_out")
		fadetimer.start()
