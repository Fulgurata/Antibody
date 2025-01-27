#idle_state
extends PlayerState

func enter_state(player_node) -> void:
	super(player_node) #call parent class method (player_state.gd class "PlayerState")
	$"../PlayerSprite".play("leg")

func get_input() -> Vector2:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	player.look_at(player.get_global_mouse_position())
	player.velocity = direction * player.max_speed
	if direction.length() > 1.0:
		direction = direction.normalized()
	return direction


func handle_input(_delta) -> void:
	var direction = get_input()
	#get_input()
	#print("playerMoving")
	if direction.length() > 0:
		player.move_and_slide()
	else:
		player.change_state("Idle")
		#print("playerMoving_toIdle")
	if direction.length() > 0:
		player.change_state("Moving")
	
	elif Input.is_action_just_pressed("dodge"):
		player.change_state("Dodging")
		#print("playerMoving_toDodge")
