extends Node2D

var button_type = null

func _ready():
	$OptionsMenu.visible = false
	$Main_Menu_Theme.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

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
	$Main_Button_Container.visible = false
	$OptionsMenu.visible = true


func _on_fade_timer_timeout() -> void:
	if button_type == "start" :
		get_tree().change_scene_to_file("res://scenes/levels/top_side_level/top_side_level.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

	if button_type == "quit" :
		get_tree().quit()

	if button_type == "options" :
		pass
