#enemy_melee_atk_state.gd
extends EnemyState

func enter_state(enemy_node) -> void:
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	enemy.enemy_sprite.play("enemy_one_slash")
	#print("enemy_one_melee_ATK")

func exit_state() -> void:
	pass #placeholderin base

func process(_delta: float) -> void:
	#attack if the player is close enough to do so
	var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
	if distance_to_player <= enemy.MIN_DISTANCE:
		enemy.change_state("Enemy_MeleeAtk")
		#print("Enemy_Melee_ATK")
		#print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!You're dead!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	elif distance_to_player > enemy.MIN_DISTANCE and enemy.is_jumping == false:
		#print("Melee_ATK_to_Moving")
		enemy.change_state("Enemy_Moving")
	elif enemy.is_jumping == false:
		#print("EnemyMelee_ATK_toIdle")
		enemy.change_state("Enemy_Idle")
		#print("after zeroing", enemy.chosen_dir)
