#idle_state
extends PlayerState

func enter_state(player_node) -> void:
	super(player_node) #call parent class method (player_state.gd class "PlayerState")
	$"../PlayerSprite".play("leg")
	#player.velocity.x = 0
	#player.velocity.y = 0

func handle_input(_delta) -> void:
	#get your input
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	#print("playerIdle")
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if direction.length() > 0:
		player.change_state("Moving")
		#print("playerIdle_toMoving")
	
	elif Input.is_action_just_pressed("dodge"):
		player.change_state("Dodging")
		#print("playerIdle_toDodge")
		
	player.rotation = (player.get_global_mouse_position() - player.position).angle()
