extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_fade_timer_timeout() -> void:
	print("you died menu incoming")
	get_tree().change_scene_to_file("res://scenes/menus/you_died/you_died.tscn")
