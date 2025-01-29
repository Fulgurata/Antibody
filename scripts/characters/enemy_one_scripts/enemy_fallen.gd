extends EnemyState

@onready var interaction_area: InteractionArea = $"../interaction_area"


func enter_state(enemy_node) -> void:
	InteractionManager.can_interact = true
	interaction_area.visible = true
	super(enemy_node) #call parent class method (player_state.gd class "PlayerState")
	enemy.enemy_sprite.play("enemy_one_fall")
	for shape in enemy.get_children():
		if shape is Area2D and shape != interaction_area:
			shape.queue_free()
	for shape in enemy.get_children():
		if shape is CollisionShape2D and shape != interaction_area:
			shape.queue_free()

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	print("i'm working")
	enemy.enemy_sprite.play("enemy_one_stomp")
	for shape in enemy.get_children():
		if shape is Area2D:
			shape.queue_free()
	for shape in enemy.get_children():
		if shape is CollisionShape2D:
			shape.queue_free()
