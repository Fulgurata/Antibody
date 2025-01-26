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
	#print("enemy_one_dead")

func process(_delta) -> void:
	pass
