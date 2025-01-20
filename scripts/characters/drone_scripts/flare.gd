extends Node2D


func _ready():
	$Flare.play()


func _on_flare_timer_timeout() -> void:
	queue_free()
