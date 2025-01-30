extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var direction: Vector2 = Vector2.ZERO
const SPEED: float = 2000.0
var picked_up: bool = true


func _ready() -> void:
	sprite.play("knife_thrown")
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		#global_position += direction * SPEED * delta
		velocity = direction * SPEED
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collided_body = collision.get_collider()
			if not collided_body.is_in_group("player") and not collided_body.is_in_group("bullet") and not collided_body.is_in_group("knife"):
				picked_up = false
				sprite_2d.visible = true
				sprite.visible = false
				


func _on_area_entered(area: Area2D) -> void:
	if picked_up == false:
		if area.is_in_group("player"):
			var player: CharacterBody2D = get_tree().get_current_scene().find_child("Player")
			print(player)
			player.has_knife_fo_real()
			picked_up = true
			queue_free()  # Remove the pickup
		else:
			print("No knife")


func _on_knife_pickup_area_exited(_area: Area2D) -> void:
	picked_up = false
