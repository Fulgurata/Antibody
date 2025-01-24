extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
const SPEED: float = 2000.0
@export var damage: int = 1

func _ready() -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position += direction * SPEED * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		if "take_damage" in area:
			area.take_damage(damage)
	
