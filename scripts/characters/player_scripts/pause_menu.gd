#PauseMenu script
extends VBoxContainer

var button_type = null
var last_path: String = ""
@onready var options_menu = get_tree().get_current_scene().find_child("PauseOptionsMenu")
@onready var fader = get_tree().get_current_scene().find_child("Fade_Transition")
@onready var faderanim = get_tree().get_current_scene().find_child("AnimationPlayer")
@onready var fadetimer = get_tree().get_current_scene().find_child("PauseFadeTimer") #Special timer, because this one needs to connect back here... There's definitely a better way to do all this.


func _ready():
	self.visible = false
	options_menu.visible = false
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_options_pressed() -> void:
	button_type = "options"
	self.visible = false
	options_menu.visible = true

func _on_try_again_pressed() -> void:
	button_type = "TryAgain"
	last_path = GameState.last_scene_path
	fader.show()
	faderanim.play("fade_out")
	fadetimer.start()

func _on_main_menu_pressed() -> void:
	button_type = "MainMenu"
	fader.show()
	faderanim.play("fade_out")
	fadetimer.start()
	#get_tree().quit()


func _on_pause_fade_timer_timeout() -> void:
	if button_type == "TryAgain" :
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
