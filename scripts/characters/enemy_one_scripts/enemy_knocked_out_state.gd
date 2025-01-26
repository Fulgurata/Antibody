#knocked_out_state
extends EnemyState

func enter_state(enemy_node) -> void:
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	enemy.enemy_sprite.play("gory_death")
	#print("enemy_one_dead")

func process(_delta) -> void:
	pass
