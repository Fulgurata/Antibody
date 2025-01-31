extends CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var player = get_parent().find_child("Player")
@export var MIN_DISTANCE: float = 500.0
@export var max_health: int = 2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var current_path: String = get_tree().get_current_scene().scene_file_path



var death = false
var current_state: Boss_State
var health: int = max_health:
	set(value):
		health = max(value, 0)
 
var direction = Vector2.ZERO
var speed  = 150.0
 
func _ready():
	$AudioStreamPlayer2D.play()
	set_physics_process(false)
 
func _process(_delta):
	if death == false:
		direction = (player.position - global_position).normalized()
		ray_cast.target_position = direction * 400
		
		$AnimatedSprite2D.look_at(player.position)
		$AnimatedSprite2D.rotate(deg_to_rad(-90))
	
 
func _physics_process(_delta):
	if death == false:
		velocity = direction * speed
		move_and_slide()
 
func _on_hitbox_body_entered(body: Node2D) -> void:
	if death == false:
		if body.is_in_group("bullet"):
				health -= 1
				if health <= 0:
					die()
		else:
			print("Can't be stopped!")

func die():
	sprite.play("Death")
	print("Boss has been defeated.")
	death = true
	if current_path == "res://scenes/levels/top_side_level/top_side_level.tscn":
		GameState.Level1KillCount += 1
	elif current_path == "res://scenes/levels/Level2/level_2.tscn":
		GameState.Level2KillCount += 1
	elif current_path == "res://scenes/levels/level_4/level_4.tscn":
		GameState.Level3KillCount += 1
	for shape in self.get_children():
		if shape is Area2D:
			shape.queue_free()
	for shape in self.get_children():
		if shape is CollisionShape2D:
			shape.queue_free()
	$AudioStreamPlayer2D.stop()
