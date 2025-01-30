extends Boss_State

class_name DeadState
@onready var boss: CharacterBody2D = $"../.."
@onready var interaction_area: InteractionArea = $"../../interaction_area"

func enter():
	$"../../AnimatedSprite2D".play("Boss_dying")
	interaction_area.collision_mask = 3
	InteractionManager.can_interact = true
	interaction_area.visible = true
	interaction_area.interact = Callable(self, "_on_interact")
	for shape in boss.get_children():
		if shape is Area2D and shape != interaction_area:
			shape.queue_free()
	for shape in boss.get_children():
		if shape is CollisionShape2D and shape != interaction_area:
			shape.queue_free()


func _on_interact():
	print("i'm working")
	InteractionManager.unregister_area(interaction_area)
	for shape in boss.get_children():
		if shape is Area2D:
			shape.queue_free()
	for shape in boss.get_children():
		if shape is CollisionShape2D:
			shape.queue_free()
