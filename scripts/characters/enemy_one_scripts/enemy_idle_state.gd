#idle_state
extends EnemyState

func enter_state(enemy_node) -> void:
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	enemy.enemy_sprite.play("enemy_one_idle")
	#print("enemy_one_idle")

func process(_delta) -> void:
	enemy.update_context_arrays()
	if enemy.chosen_dir.length() > 0 and enemy.is_jumping == false:
		#print("enemy_Idle_toMoving")
		enemy.change_state("Enemy_Moving")
