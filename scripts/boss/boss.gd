extends CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var player = get_parent().find_child("Player")
@onready var progress_bar = $ProgressBar
@export var MIN_DISTANCE: float = 500.0
@export var max_health: int = 50

var death = false
var current_state: Boss_State
var health: int = max_health:
	set(value):
		health = max(value, 0)
		progress_bar.value = value
 
var direction = Vector2.RIGHT
var speed  = 150.0
 
func _ready():
	$AnimatedSprite2D.play("Boss_idle")
	set_physics_process(false)
	progress_bar.max_value = max_health
	progress_bar.value = max_health
 
func _process(_delta):
	direction = (player.position - global_position).normalized()
	ray_cast.target_position = direction * 400
	
	$AnimatedSprite2D.look_at(player.position)
	$AnimatedSprite2D.rotate(deg_to_rad(-90))
 
func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()
 


func die():
	print("Boss has been defeated.")
	death = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
			health -= 1
			if health <= 0:
				$AnimatedSprite2D.play("Boss_downed")
				die()
	else:
		print("Can't be stopped!")
