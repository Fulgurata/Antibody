#dodge_state.gd
extends PlayerState

var steering_factor := 10.0
var dodge_speed : float = 3500.0 #dash speed
var dodge_direction : Vector2 = Vector2(0,0) #dash direction
var dodge_duration : float = 0.2 #time in seconds for dodge to last
var can_dodge : bool = true #able to dash? flag
var dodge_timer : float = 0.0 #timer to track dodge duration
var velocity := Vector2 (0,0)

func enter_state(player_node) -> void:
	super(player_node) #call parent class method (player_state.gd class "PlayerState")
	dodge_timer = dodge_duration

func handle_input(delta) -> void:
	#get your input
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	# These lines create the friction effect
	var desired_velocity := dodge_speed * direction
	dodge_direction = desired_velocity - velocity
	velocity += dodge_direction * steering_factor * delta
	
	#This line makes the player move
	get_parent().get_node(player).position += velocity * delta
	dodge_timer -= delta
	
	if dodge_timer <= 0:
		if direction.length() > 1.0:
			player.change_state("MovingState")
		else:
			player.change_state("IdleState")

#func exit_state() -> void:
	#pass #placeholderin base
