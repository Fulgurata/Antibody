#moving_state.gd
extends EnemyState

func enter_state(player_node) -> void:
	super(player_node) #call parent class method (player_state.gd class "PlayerState")

func exit_state() -> void:
	pass #placeholderin base


#func get_input() -> Vector2:
	#var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#enemy.look_at(enemy.get_global_mouse_position())
	#enemy.velocity = direction * enemy.max_speed
	#if direction.length() > 1.0:
		#direction = direction.normalized()
	#return direction


#func handle_input(_delta) -> void:
	#var direction = get_input()
	##get_input()
	#print("enemy_Moving")
	#if direction.length() > 0:
		#enemy.move_and_slide()
	#else:
		#enemy.change_state("Enemy_Idle")
		#print("enemy_Moving_toIdle")
	#if direction.length() > 0:
		#enemy.change_state("Enemy_Moving")
	
