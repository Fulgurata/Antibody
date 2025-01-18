extends Area2D


@onready var door = get_parent().get_node("door")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		door.open_door()
