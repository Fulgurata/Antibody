extends CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var player = get_parent().find_child("Player")
@export var MIN_DISTANCE: float = 500.0
@export var max_health: int = 2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var death = false
var current_state: Boss_State
var health: int = max_health:
	set(value):
		health = max(value, 0)
 
var direction = Vector2.RIGHT
var speed  = 150.0
 
func _ready():
	set_physics_process(false)
 
func _process(_delta):
	direction = (player.position - global_position).normalized()
	ray_cast.target_position = direction * 400
 
func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()
 
func _on_hitbox_body_entered(body: Node2D) -> void:
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
