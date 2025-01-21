extends Area2D




func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("ashdjsad")
		area.get_parent().set_position($Destnation_Point.global_position)
