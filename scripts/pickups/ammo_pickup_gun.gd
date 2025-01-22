extends Area2D

@export var ammo_type: String = "gun"  # Ammo type: "gun", "shotgun", or "assault_rifle"
@export var ammo_amount: int = 7       # Ammo amount to give (e.g., magazine size)
@onready var ammo_pickup_sound: AudioStreamPlayer2D = $ammo_pickup_sound

var picked_up: bool = false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_area_entered(area: Area2D) -> void:
	print("Collision detected with:", area.name)
	if picked_up == false:
		if area.is_in_group("player"):
			var gun: Node2D = get_tree().get_current_scene().find_child("Player").find_child("Gun")
			#print("Adding ammo:", ammo_type, ammo_amount)
			gun._on_ammo_pickup(ammo_type, ammo_amount) #Call add_ammo on the gun script
			picked_up = true
			ammo_pickup_sound.play()
			await ammo_pickup_sound.finished
			queue_free()  # Remove the pickup
		else:
			print("No gun script found on", area.name)
