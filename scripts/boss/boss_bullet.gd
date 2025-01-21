extends CharacterBody2D


const speed = 100

func _process(delta):
	position += transform.x * speed * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()

func _on_kill_timer_timeout() -> void:
	queue_free()
