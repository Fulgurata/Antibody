#player.gd
extends CharacterBody2D

# These are variables that are used in multiple functions 
#we'll need to clean these up at some point, we're not actually using them all I don't think
var steering_factor := 0.9 #must be between 0 and 1.0
var normal_speed := 400.0
var current_state
@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var player = null
@export var MIN_DISTANCE: float = 0.0

var vision_range = 700
var num_rays = 32

# context array *Basically, these arrays store the directions the thing can go, the bad directions, and the good directions, later we'll do math (good - bad = go that way)
var ray_directions = []
var interest = []
var danger = []
var chosen_dir = Vector2.ZERO


func _ready():
	#await get_tree().process_frame
	await owner.ready
	player = get_tree().get_current_scene().find_child("Player")
	if not player:
		print("Player not found in parent node!")
	change_state("Enemy_Idle") # Start in the Idle state
	$EnemySprite.play("enemy_one_walk") #play animation ((fix this later, we need to play different animations for different states)
	#print("Enemy_Ready_toIdle")
	#all this jazz allows you to adjust the ray count on the fly for max performance, without all the math breaking
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in range(num_rays):
			var angle = i * 2 * PI / num_rays
			ray_directions[i] = Vector2.RIGHT.rotated(angle)
			interest[i] = 0.0
			danger[i] = 0.0
	#end jazz
	

##draw the rays for debugging purposes. (draw must be localized, rays must be global, dammmmnnniiiiittttttttt)
	#_draw()
#
#func _draw()-> void:
	##print("Enemy global position:", global_position)
	#for i in range(num_rays):
		#draw_line(to_local(enemy_sprite.global_position), to_local(enemy_sprite.global_position) + ray_directions[i].rotated(rotation) * vision_range, Color.GREEN, 1.0)
	#var distance_to_player = global_position.distance_to(player.global_position)
	#if distance_to_player > MIN_DISTANCE:
		#var desired_velocity = chosen_dir.rotated(rotation) * normal_speed
		#draw_line(enemy_sprite.global_position, desired_velocity, Color.RED, 1.0)


func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state() #Exit the current state
	current_state = get_node(new_state_name)

	if current_state: #Ensure the new state exists
		current_state.enter_state(self) # Enter the new state

func _process(delta: float) -> void:
	if current_state:
		current_state.handle_input(delta)
	
	#populate context arrays
	update_context_arrays()
	
	#move the dude (move this to movement state asap)
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > MIN_DISTANCE:
		#velocity = (player.global_position - global_position).normalized() * normal_speed
		var desired_velocity = chosen_dir.rotated(rotation) * normal_speed
		velocity = velocity.lerp(desired_velocity, steering_factor) #linear_interpolate is now "lerp"
		rotation = velocity.angle() #(get rotated bro)
		move_and_collide(velocity * delta)
	else:
		velocity = Vector2.ZERO

func update_context_arrays() -> void:
	for i in range(num_rays):
		set_interest(i)
		set_danger(i)
		if danger[i] > 0.0 and interest[i] > 0.0:
			interest[i] -= danger[i]
			interest[i] = max(0, interest[i])
		if i == 0:
			chosen_dir = Vector2.ZERO
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()

#Cast rays to find good directions (currently only includes "toward the player")
func set_interest(i: int)-> void:
	var space_state = get_world_2d().get_direct_space_state()
	var params = PhysicsRayQueryParameters2D.new()
	params.from = enemy_sprite.global_position
	params.to = enemy_sprite.global_position + ray_directions[i].rotated(rotation) * vision_range
	#print("Enemy global position:", global_position)
	params.exclude = [self]
	#params.collision_mask = 10
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var result = space_state.intersect_ray(params)

	if result:
		
		if result.collider.is_in_group("player"):
			interest[i] = 1.0
			#print("hit_player")
		elif result.collider.is_in_group("drone"):
			interest[i] = 0.7
			#print("hit_drone")
		#else:
			#print("hit non-player interest")
	else:
		interest[i] = 0.0
		#print("no_interest")
	#here we could setup a random wander pattern by having it pick a random spot nearby every 30 seconds
	#just add a random value to current global position and make that your new favorite spot



#Cast rays to find bad directions
#collision mask doesn't seem to work, setting it to 10 makes the rays fail, even if the player is also set to 10.
func set_danger(i: int):
	var space_state_d = get_world_2d().get_direct_space_state()
	var params_d = PhysicsRayQueryParameters2D.new()
	params_d.from = enemy_sprite.global_position
	params_d.to = enemy_sprite.global_position + ray_directions[i].rotated(rotation) * vision_range
	params_d.exclude = [self,player.get_rid()]
	#print("Enemy global position:", global_position)
	#params_d.collision_mask = 10
	params_d.collide_with_areas = true
	params_d.collide_with_bodies = true
	
	var result = space_state_d.intersect_ray(params_d)
	if result:
		danger[i] = 0.5
		#print("wall")
	else:
		danger[i] = 0.0
		#print("no_danger")
