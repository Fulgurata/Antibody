extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
const SPEED: float = 2000.0

func _ready() -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position += direction * SPEED * delta
	#position += transform.x * SPEED * delta
	#rotation = (get_global_mouse_position() - position).angle()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		get_tree().get_current_scene().find_child("UI").set_zombie_count(1)
		#print("I'm a bullet!")
