#player.gd
extends CharacterBody2D

# These are variables that are used in multiple functions 
var steering_factor := 10.0
var normal_speed := 600.0
var boost_speed := 1500.0
var max_speed := normal_speed
var friction := 0.5
var current_state
var rotation_direction = 0
var rotation_speed = 1.5
var health = 3
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var fader = get_tree().get_current_scene().find_child("Fade_Transition")
@onready var faderanim = get_tree().get_current_scene().find_child("AnimationPlayer")
@onready var fadetimer = get_tree().get_current_scene().find_child("Fade_Timer")

func _ready():
	change_state("Idle") # Start in the Idle state
	#print("playerReady_toIdle")

func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state() #Exit the current state
	current_state = get_node(new_state_name)

	if current_state: #Ensure the new state exists
		current_state.enter_state(self) # Enter the new state

func _process(delta: float) -> void:
	rotation = (get_global_mouse_position() - position).angle()#velocity.angle()
	
	if current_state:
		current_state.handle_input(delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("hit")
	if area.is_in_group("bullet") or area.is_in_group("enemyarea") or area.is_in_group("enemy"):
		health -= 1
		print("Hit! Health:", health)

	if health <= 0:
		#print("He dead Jim.")
		var current_path: String = get_tree().get_current_scene().scene_file_path
		GameState.last_scene_path = current_path
		fader.show()
		fadetimer.start()
		faderanim.play("fade_out")
