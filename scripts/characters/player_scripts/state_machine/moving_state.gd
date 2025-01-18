#moving_state.gd
extends PlayerState

func enter_state(player_node) -> void:
	super(player_node) #call parent class method (player_state.gd class "PlayerState")

func exit_state() -> void:
	pass #placeholderin base

func handle_input(delta) -> void:
	#get your input
	var direction := Vector2(0, 0)
	print(direction)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	print("playerMoving")
	print(direction)
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		print(direction)
	
	if direction.length() > 0:
		# These lines create the friction effect
		var desired_velocity : Vector2 = player.max_speed * direction
		var steering_vector : Vector2 = desired_velocity - player.velocity
		player.velocity += steering_vector * player.steering_factor * delta
	
		#This line makes the player move
		player.position += player.velocity * delta
	
		# These lines make the sprite face the direction it moves
		#if direction.length() > 0.0:#commented out WASD movement, too awkward, can't shoot at angles
		player.rotation = (player.get_global_mouse_position() - player.position).angle()
		print("playershouldbemovingaround")
		print(direction)
		
	else:
		#player.change_state("Idle")
		print("playerMoving_toIdle")
	
	if direction.length() > 0:
		player.change_state("Moving")
	
	elif Input.is_action_just_pressed("dodge"):
		player.change_state("Dodging")
		print("playerMoving_toDodge")
		
		
	
