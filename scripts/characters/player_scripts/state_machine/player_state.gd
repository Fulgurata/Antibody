#player_state
#base class for player states
extends Node
class_name PlayerState

var player

func enter_state(player_node) -> void:
	player = player_node

func exit_state() -> void:
	pass #placeholderin base

func handle_input(_delta) -> void:
	pass #no input handling in base state
