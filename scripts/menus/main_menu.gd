extends Node2D

var button_type = null

func _on_start_pressed() -> void:
	button_type = "start"
	$Fade_Transition.show()
	$Fade_Transition/Fade_Timer.start()
	$Fade_Transition/AnimationPlayer.play("fade_out")
	#get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_quit_pressed() -> void:
	button_type = "quit"
	$Fade_Transition.show()
	$Fade_Transition/Fade_Timer.start()
	$Fade_Transition/AnimationPlayer.play("fade_out")
	#get_tree().quit()


func _on_options_pressed() -> void:
	button_type = "options"
	$Fade_Transition.show()
	$Fade_Transition/Fade_Timer.start()
	$Fade_Transition/AnimationPlayer.play("fade_out")


func _on_fade_timer_timeout() -> void:
	if button_type == "start" :
		get_tree().change_scene_to_file("res://scenes/levels/level_one/LevelOne.tscn")

	if button_type == "quit" :
		get_tree().quit()

	if button_type == "options" :
		get_tree().change_scene_to_file("res://scenes/menus/main_menu/options_menu.tscn")
