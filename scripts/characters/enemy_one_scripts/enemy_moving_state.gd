#moving_state.gd
extends EnemyState

func enter_state(enemy_node) -> void:
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	enemy.enemy_sprite.play("enemy_one_walk")
	#print("enemy_one_moving")

func exit_state() -> void:
	pass #placeholderin base

func process(delta: float) -> void:
	#populate context arrays
	enemy.update_context_arrays()
	
	#move the dude
	var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
	var rng = RandomNumberGenerator.new()
	#print("jump - 25: ", enemy.Jump_Distance - 25)
	#print("distance: ", distance_to_player)
	#print("jump chance: ", enemy.Jump_Likely)
	#print("random: ", rng.randf_range(0.0, 1.0))
	#print("close enough to jump?		", distance_to_player > (enemy.Jump_Distance - 25) and distance_to_player < (enemy.Jump_Distance + 25))
	#print("coinflip?		", enemy.Jump_Likely > rng.randf_range(0.0, 1.0))
	
	if distance_to_player > (enemy.Jump_Distance - 10) and distance_to_player < (enemy.Jump_Distance + 10) and enemy.Jump_Likely > rng.randf_range(0.0, 1.0) and enemy.jump_recharge == true:
		print("Moving_to_Enemy_Jumping")
		enemy.change_state("Enemy_Jumping")
	elif distance_to_player <= enemy.MIN_DISTANCE and enemy.is_jumping == false:
		print("Moving_to_Melee_ATK")
		enemy.change_state("Enemy_MeleeAtk")
	elif distance_to_player > enemy.MIN_DISTANCE and enemy.is_jumping == false:
		var desired_velocity = enemy.chosen_dir.rotated(enemy.rotation) * enemy.normal_speed
		enemy.velocity = enemy.velocity.lerp(desired_velocity, enemy.steering_factor) #linear_interpolate is now "lerp"
		enemy.rotation = enemy.velocity.angle() #(get rotated bro)
		#velocity = Vector2.ZERO#activate to make him stop moving for testing purposes
		enemy.move_and_collide(enemy.velocity * delta)
		enemy.chosen_dir = Vector2.ZERO
		print("Moving_to_Moving")
		enemy.change_state("Enemy_Moving")
		#print("after zeroing", chosen_dir)
	elif enemy.is_jumping == false:
		enemy.velocity = Vector2.ZERO
		enemy.chosen_dir = Vector2.ZERO
		print("EnemyMoving_toIdle")
		enemy.change_state("Enemy_Idle")
		#print("after zeroing", enemy.chosen_dir)
