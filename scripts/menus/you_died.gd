#YouDied Menu script
extends Node2D

var button_type = null

func _ready():
	$OptionsMenu.visible = false
	$Main_Menu_Theme.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_options_pressed() -> void:
	button_type = "options"
	$Main_Button_Container.visible = false
	$OptionsMenu.visible = true


func _on_try_again_pressed() -> void:
	button_type = "TryAgain"
	$Fade_Transition.show()
	$Fade_Transition/Fade_Timer.start()
	$Fade_Transition/AnimationPlayer.play("fade_out")
	#get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_main_menu_pressed() -> void:
	button_type = "MainMenu"
	$Fade_Transition.show()
	$Fade_Transition/Fade_Timer.start()
	$Fade_Transition/AnimationPlayer.play("fade_out")
	#get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "TryAgain" :
		var last_path = GameState.last_scene_path
		if last_path != "": #just to be safe
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			get_tree().change_scene_to_file(last_path)
		else:
		#Fallback
			print("Error:No prior scene found, defaulting to main menu")
			get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")

	if button_type == "MainMenu" :
		get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")

	if button_type == "options" :
		pass
