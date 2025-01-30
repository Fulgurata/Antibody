#knocked_out_state
extends EnemyState
@onready var hit_box: Area2D = $"../HitBox"
@onready var collision_shape_2d: CollisionShape2D = $"../CollisionShape2D"


func enter_state(enemy_node) -> void:
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	enemy.enemy_sprite.play("gory_death")
	for shape in enemy.get_children():
		if shape is Area2D:
			shape.queue_free()
	for shape in enemy.get_children():
		if shape is CollisionShape2D:
			shape.queue_free()
	
	if enemy.current_path == "res://scenes/levels/top_side_level/top_side_level.tscn":
		GameState.Level1KillCount += 1
		print(GameState.Level1KillCount)
	elif enemy.current_path == "res://scenes/levels/Level2/level_2.tscn":
		GameState.Level2KillCount += 1
	elif enemy.current_path == "res://scenes/levels/level_4/level_4.tscn":
		GameState.Level3KillCount += 1
	
	
	#print("enemy_one_dead")

func process(_delta) -> void:
	pass
