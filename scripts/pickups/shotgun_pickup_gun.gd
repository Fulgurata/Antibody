extends Area2D

  # Ammo type: "gun", "shotgun", or "assault_rifle"

var picked_up: bool = false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_area_entered(area: Area2D) -> void:
	print("Collision detected with:", area.name)
	if picked_up == false:
		if area.is_in_group("player"):
			var gun: Node2D = get_tree().get_current_scene().find_child("Player").find_child("Gun")
			if gun and gun.has_method("_on_weapon_pickup"):
				gun._on_weapon_pickup("shotgun", 2)  # Unlock the weapon in the gun script
				picked_up = true
		   # weapon_pickup_sound.play()
		  #  await weapon_pickup_sound.finished
				queue_free()  # Remove the weapon pickup from the scene
			else:
				print("No gun script found or '_on_weapon_pickup' method missing.")
