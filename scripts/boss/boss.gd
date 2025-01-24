extends CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var player = get_parent().find_child("Player")
@onready var progress_bar = $ProgressBar
@export var MIN_DISTANCE: float = 500.0
@export var max_health: int = 10

var current_state: Boss_State
var health: int = max_health:
	set(value):
		health = max(value, 0)
		progress_bar.value = value
 
var direction = Vector2.RIGHT
var speed  = 75.0
 
func _ready():
	set_physics_process(false)
 
func _process(_delta):
	direction = (player.position - global_position).normalized()
	ray_cast.target_position = direction * 400
 
func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()
 


func die():
	print("Boss has been defeated.")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if current_state == VulnerableState:
		if body.is_in_group("bullet"):
			health -= 1
	else:
		print("Can't be stopped!")
