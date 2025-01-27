#knocked_out_state
extends PlayerState

func enter_state(player_node) -> void:
	super(player_node) #call parent class method (player_state.gd class "PlayerState")
	$"../PlayerSprite".play("leg")
