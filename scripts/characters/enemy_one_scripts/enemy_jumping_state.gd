#enemy_jumping_state.gd
extends EnemyState

var jumpvector: Vector2 = Vector2.ZERO

func enter_state(enemy_node) -> void:
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	enemy.is_jumping = true
	enemy.update_context_arrays()
	animate_jump()
	print("entered_Jump")

func exit_state() -> void:
	#enemy.velocity = Vector2.ZERO
	print("left_Jump")
#
func process(delta: float) -> void:
	#populate context arrays
	#enemy.update_context_arrays()
	#He jump
	var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
	if distance_to_player > enemy.MIN_DISTANCE and enemy.is_jumping == true:
		var desired_velocity = enemy.chosen_dir.rotated(enemy.rotation) * (enemy.normal_speed * enemy.jump_factor)
		enemy.velocity = enemy.velocity.lerp(desired_velocity, enemy.steering_factor) #linear_interpolate is now "lerp"
		enemy.rotation = enemy.velocity.angle() #(get rotated bro)
		#velocity = Vector2.ZERO#activate to make him stop moving for testing purposes
		enemy.move_and_collide(enemy.velocity * delta)
		print("Jumping_to_Jumping")
		enemy.change_state("Enemy_Jumping")
	elif distance_to_player > enemy.MIN_DISTANCE and enemy.is_jumping == false:
		print("Jumping_to_Moving")
		enemy.change_state("Enemy_Moving")
		##print("after zeroing", chosen_dir)
	elif distance_to_player <= enemy.MIN_DISTANCE and enemy.is_jumping == false:
		print("Moving_to_Melee_ATK")
		enemy.change_state("Enemy_MeleeAtk")
	elif enemy.is_jumping == false:
		enemy.velocity = Vector2.ZERO
		enemy.chosen_dir = Vector2.ZERO
		print("EnemyMoving_toIdle")
	#enemy.change_state("Enemy_Idle")
	#print("after zeroing", enemy.chosen_dir)

func animate_jump() -> void:
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.wait_time = enemy.airtime
	timer.one_shot = true
	enemy.enemy_sprite.play("enemy_one_windup", 5)
	enemy.enemy_sprite.play("enemy_one_jump", 1 / enemy.airtime)
	print("enemy_one_jumping_animation")
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	enemy.is_jumping = false
	enemy.jump_recharge = false
	#pass
