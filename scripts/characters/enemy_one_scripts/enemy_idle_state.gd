#idle_state
extends EnemyState

func enter_state(enemy_node) -> void:
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	#player.velocity.x = 0
	#player.velocity.y = 0

func handle_input(_delta) -> void:
	#get your input
	var direction := Vector2(0, 0)
	#print("enemy_Idle")
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if direction.length() > 0:
		enemy.change_state("Enemy_Moving")
		#print("enemy_Idle_toMoving")
