#player.gd
extends CharacterBody2D

# These are variables that are used in multiple functions 
var steering_factor := .5 #must be between 0 and 1.0
var normal_speed := 400.0
var current_state
@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var player = null
@export var MIN_DISTANCE: float = 50.0 #how close the enemy will get before stopping
var health = 2

var vision_range = 800 #how far the enemy can see (does not need light)
var num_rays = 64 #the fidelity of the enemies vision, may need to decrease for performance if lagging occurs

# context array *Basically, these arrays store the directions the thing can go, the bad directions, and the good directions, later we'll do math (good - bad = go that way)
var ray_directions = []
var interest = []
var danger = []
var chosen_dir = Vector2.ZERO

var player_sighted_ray_flag = []#if it sees the player, store that direction so we can ignore the drone
var count_cycle = 0 #count how many times we've gone around the circle of rays

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
	player_sighted_ray_flag.resize(num_rays)
	for i in range(num_rays):
			var angle = i * 2 * PI / num_rays
			ray_directions[i] = Vector2.RIGHT.rotated(angle)
			interest[i] = 0.0
			danger[i] = 0.0
			player_sighted_ray_flag[i] = false
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
		#velocity = Vector2.ZERO#activate to make him stop moving for testing purposes
		move_and_collide(velocity * delta)
		chosen_dir = Vector2.ZERO
		#print("after zeroing", chosen_dir)
	else:
		velocity = Vector2.ZERO
		chosen_dir = Vector2.ZERO
		#print("after zeroing", chosen_dir)



func update_context_arrays() -> void:
	for i in range(num_rays):
		set_interest(i)
		set_danger(i)
		if danger[i] > 0.0:# or interest[i] > 0.0:
			interest[i] -= danger[i]
			#interest[i] = max(0, interest[i])
		if i == 0:
			#chosen_dir = Vector2.ZERO#I don't remember why we were doing this...
			#this little block lets the enemy remember the player for a second (maybe, I don't know, how long is a delta?
			count_cycle += 1
			if count_cycle >= 30:
				player_sighted_ray_flag[i] = false
			elif count_cycle >= 32: #the maximum number of ray cycles before the count resets and enemy can chase the drone again
				count_cycle = 0
		chosen_dir += ray_directions[i] * interest[i]
		#print("after adding ray#: ", i, chosen_dir)
		#print("RAY number: ", i, "   interest: ", interest[i], "   direction: ", ray_directions[i])
	chosen_dir = chosen_dir.normalized()
	#print("after normalizing post rayZ", chosen_dir)



#Cast rays to find good directions (currently only includes "toward the player")
func set_interest(i: int)-> void:
	var space_state = get_world_2d().get_direct_space_state()
	var params = PhysicsRayQueryParameters2D.new()
	params.from = enemy_sprite.global_position
	params.to = enemy_sprite.global_position + ray_directions[i].rotated(rotation) * vision_range
	params.exclude = [self]
	#params.collision_mask = 10
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var result = space_state.intersect_ray(params)

	if result:
		#var collision_distance = result.position.distance_to(enemy_sprite.global_position)
		#print("Ray number: ", i,"interest_collider:	", result.collider, "		Distance: 	", collision_distance)
		
		if result.collider.is_in_group("player"):
			interest[i] = 0.9
			player_sighted_ray_flag[i] = true
			#print(result.collider.position)
		elif result.collider.is_in_group("drone") and player_sighted_ray_flag.has(true):
			interest[i] = 0.7
			#print("hit_drone")
		else:
			interest[i] = 0.0
			#print("hit non-player interest")
	else:
		interest[i] = 0.0
		#print("no_interest")
	#print("Ray number: ", i,"		set_interest: 	", interest[i])
	#here we could setup a random wander pattern by having it pick a random spot nearby every 30 seconds
	#just add a random value to current global position and make that your new favorite spot



#Cast rays to find bad directions
#collision mask doesn't seem to work, setting it to 10 makes the rays fail, even if the player is also set to 10.
func set_danger(i: int):
	var space_state_d = get_world_2d().get_direct_space_state()
	var params_d = PhysicsRayQueryParameters2D.new()
	params_d.from = enemy_sprite.global_position
	params_d.to = enemy_sprite.global_position + ray_directions[i].rotated(rotation) * vision_range
	params_d.exclude = [self]
	#params_d.collision_mask = 10
	params_d.collide_with_areas = false
	params_d.collide_with_bodies = true
	
	var result = space_state_d.intersect_ray(params_d)
	if result:
		var collision_distance = result.position.distance_to(enemy_sprite.global_position)
		#print("Ray number: ", i,"danger_collider:	", result.collider, result.collider.name, result.collider.name == "Player", "		Distance: 	", collision_distance)
		var max_wall_care = 35.0 #the distance we want to detect and avoid walls, 50 is very small, 23 is "you're on top of me", 35 seems to be about right for our tilesizes
		if result and collision_distance < max_wall_care and result.collider.name != "Player":
			danger[i] = 0.5
			#print(ratio)
		else:
			danger[i] = 0.0
			#print("no_danger")
	else:
		danger[i] = 0.0
	#print("Ray number: ", i,"		set_danger: 	", danger[i])


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		health -= 1
		print("Hit! Health:", health)

	if health <= 0:
		print("He dead Jim.")
		queue_free()
