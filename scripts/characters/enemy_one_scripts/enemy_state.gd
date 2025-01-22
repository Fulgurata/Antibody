#player_state
#base class for player states
extends Node
class_name EnemyState

var enemy

func enter_state(enemy_node) -> void:
	enemy = enemy_node

func exit_state() -> void:
	pass #placeholderin base

func process(_delta) -> void:
	pass #no input handling in base state
