extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
const SPEED: float = 2000.0
@export var damage: int = 1

func _ready() -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		#global_position += direction * SPEED * delta
		velocity = direction * SPEED
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collided_body = collision.get_collider()
			if not collided_body.is_in_group("player") and not collided_body.is_in_group("bullet"):
				queue_free()


	
