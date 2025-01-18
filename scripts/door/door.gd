extends Area2D

var is_open = false

func _on_Area2D_body_entered(Area):
	if Area.is_in_group("player"):
		open_door()
		
func open_door():
	if not is_open:
		is_open = true
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true


func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		open_door()
