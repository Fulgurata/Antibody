extends Area2D

class_name InteractionArea

@export var action_name: String = "interact"


var interact: Callable = func():
	pass




func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("sup")
		InteractionManager.register_area(self)


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		InteractionManager.unregister_area(self)
