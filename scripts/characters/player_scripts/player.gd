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
var health = 10000
var has_knife = true
const KNIFE = preload("res://scenes/knife/knife.tscn")
@onready var current_path: String = ""
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var fader = get_tree().get_current_scene().find_child("Fade_Transition")
@onready var faderanim = get_tree().get_current_scene().find_child("AnimationPlayer")
@onready var fadetimer = get_tree().get_current_scene().find_child("Fade_Timer")
@onready var pausemenu = get_tree().get_current_scene().find_child("PauseMenu")
@onready var top_player_sprite: AnimatedSprite2D = $TopPlayerSprite

@onready var scoreUI: HBoxContainer = get_tree().get_current_scene().find_child("scoreUI")
@onready var current_time: Label = get_tree().get_current_scene().find_child("current_time")
@onready var current_kills: Label = get_tree().get_current_scene().find_child("current_kills")
@onready var jump_timer: Timer = get_tree().get_current_scene().find_child("Jump_Timer")

var paused: bool = false

func _ready():
	change_state("Idle") # Start in the Idle state
	current_path = get_tree().get_current_scene().scene_file_path
	GameState.last_scene_path = current_path
	#print("playerReady_toIdle")

func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state() #Exit the current state
	current_state = get_node(new_state_name)

	if current_state: #Ensure the new state exists
		current_state.enter_state(self) # Enter the new state



func _process(delta: float) -> void:
	rotation = (get_global_mouse_position() - position).angle()#velocity.angle()
	update_score_display()
	
	if Input.is_action_just_pressed("throw_knife") and has_knife == true:
		$TopPlayerSprite.play("Knife_throw")
		has_knife = false
		var knife= KNIFE.instantiate()
		var facing_direction = Vector2(cos(self.rotation), sin(self.rotation))
		knife.direction = facing_direction.normalized()
		get_tree().root.add_child(knife)
		knife.position = global_position
		knife.rotation = global_rotation
	
	
	if Input.is_action_just_pressed("pause"):
		if paused == false:
			print("pausing")
			paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pausemenu.show()
		elif paused == true:
			print("unpausing")
			paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			pausemenu.hide()
	
	if current_state:
		current_state.handle_input(delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("hit")
	if area.is_in_group("bullet") or area.is_in_group("enemyarea") or area.is_in_group("enemy"):
		health -= 1
		print("Hit! Health:", health)
		$Camera2D.add_trauma(0.1)

	if health <= 0:
		#print("He dead Jim.")
		current_path = get_tree().get_current_scene().scene_file_path
		GameState.last_scene_path = current_path
		change_state("KnockedOut")
		fader.show()
		faderanim.play("fade_out")
		fadetimer.start()
		
		if current_path == "res://scenes/levels/top_side_level/top_side_level.tscn":
			GameState.Level1TimeScore = (jump_timer.time_left)
			GameState.TimeScore = GameState.Level1TimeScore
			GameState.KillCount = GameState.Level1KillCount
		elif current_path == "res://scenes/levels/Level2/level_2.tscn":
			GameState.Level2TimeScore = (jump_timer.time_left)
			GameState.TimeScore = GameState.TimeScore + GameState.Level2TimeScore
			GameState.KillCount = GameState.KillCount + GameState.Level2KillCount
		elif current_path == "res://scenes/levels/level_4/level_4.tscn":
			GameState.Level3TimeScore = (jump_timer.time_left)
			GameState.TimeScore = GameState.TimeScore + GameState.Level3TimeScore
			GameState.KillCount = GameState.KillCount + GameState.Level3KillCount

func update_score_display() -> void:
	if current_path == "res://scenes/levels/top_side_level/top_side_level.tscn":
		GameState.Level1TimeScore = (jump_timer.time_left)
		current_time.text = str(GameState.Level1TimeScore)
		current_kills.text = str(GameState.Level1KillCount)
	elif current_path == "res://scenes/levels/Level2/level_2.tscn":
		GameState.Level2TimeScore = (jump_timer.time_left)
		current_time.text = str(GameState.Level2TimeScore)
		current_kills.text = str(GameState.Level2KillCount)
	elif current_path == "res://scenes/levels/level_4/level_4.tscn":
		GameState.Level3TimeScore = (jump_timer.time_left)
		current_time.text = str(GameState.Level3TimeScore)
		current_kills.text = str(GameState.Level3KillCount)

func has_knife_fo_real() -> void:
	has_knife = true
