#player.gd
extends CharacterBody2D

#misc variables
var steering_factor := .2 #must be between 0 and 1.0
var normal_speed := 400.0
var health = 2
var current_state
@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var player = get_tree().get_current_scene().find_child("Player")
@export var MIN_DISTANCE: float = 50.0 #how close the enemy will get before stopping and melee attacking
@onready var scream_1: AudioStreamPlayer2D = $Scream1
@onready var scream_2: AudioStreamPlayer2D = $Scream2
@onready var scream_3: AudioStreamPlayer2D = $Scream3
@onready var hit_box: Area2D = $HitBox
@onready var current_path: String = ""

#Jumping variables, more variables for the variable throne!!!
var jump_recharge: bool = true
var is_jumping: bool = false
var jump_distance: float = 400.0 #how close the enemy needs to be before jumping
var jump_likely: float = 0.5 #how likely the enemy is to leap at the player, value between 0 and 1
var jump_factor: float = 2.0 #how fast he moves while "jumping", multiplies normal speed
var airtime = .3 # how long he jumps for
var crab_screams := [1 , 2, 3]

#context mapping settings
var vision_range = 700 #how far the enemy can see (does not need light)
var num_rays: int = 64 #the fidelity of the enemies vision, may need to decrease for performances if lagging occurs

# context array *Basically, these arrays store the directions the thing can go, the bad directions, and the good directions, later we'll do math (good - bad = go that way)
var ray_directions: Array[Vector2] = []
var interest: Array[float] = []
var danger: Array[float] = []
var chosen_dir = Vector2.ZERO
var enemy_rids = []#array for storing the RID values of all the enemies in the scene (or other things you might like your rays to ignore)

var player_sighted_ray_flag = false#if it sees the player, store it
var count_cycle = 0 #count how many times we've gone around the circle of rays
var random_dir = Vector2.ZERO #We'll pick a random direction to use for various things

func _ready():
	#await owner.ready
	if not player:
		print("Player not found in parent node!")
	change_state("Enemy_Idle") # Start in the Idle state
	print("Enemy_Ready_toIdle")
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
	
	#Get all the enemies, so they can exclude each other from the interest rays, even though it doesn't seem to work for some reason???
	var enemies = get_tree().get_nodes_in_group("enemy")
	var num_enemies = enemies.size()
	# Create an array to hold all the RIDs
	enemy_rids.resize(num_enemies)
	# Populate the array with each enemy's RID
	var ind = 0
	for e in enemies:
		if not e is CollisionShape2D: 
			enemy_rids[ind] = e.get_rid()
			ind += 1
	enemy_rids.resize(ind)

	random_dir = hare_off(ray_directions).rotated(rotation) #pick a random interesting direction
	current_path = get_tree().get_current_scene().scene_file_path #figure out what level you're in

#Don't delete this stuff, I needz it
#draw the rays for debugging purposes. (draw must be localized, rays must be global, dammmmnnniiiiittttttttt)
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
		current_state.process(delta)

func update_context_arrays() -> void:
	var new_dir = Vector2.ZERO
	for i in range(num_rays):
		set_interest(i)
		set_danger(i)
		if danger[i] > 0.0 and interest[i] == 0.0:
			interest[i] -= danger[i]
		elif danger[i] > 0.0 and interest[i] > 0.0:
			interest[i] = 0.0
			interest[(i + floor(num_rays/4)) % num_rays] = max(0.9, interest[(i + floor(num_rays/4)) % num_rays])#if he sees something between him and the player that he doesn't like, go around, + dodge bullets!
		if i == 0:
			#this little block lets the enemy remember the player for a second (maybe, I don't know, how long is a delta?)
			count_cycle += 1
			if count_cycle >= 10:
				player_sighted_ray_flag = false
			elif count_cycle >= 12: #the maximum number of ray cycles before the count resets and enemy can chase the drone again
				count_cycle = 0
		new_dir += ray_directions[i] * interest[i]
		#print("after adding ray#: ", i, chosen_dir)
		#print("RAY number: ", i, "   interest: ", interest[i], "   direction: ", ray_directions[i])
		if i == (num_rays - 1):
			pass
	if abs(new_dir.length()) < 0.1:
		new_dir = random_dir
	elif abs(new_dir.length()) >= 0.1:
		new_dir = new_dir.normalized()
	chosen_dir = chosen_dir.lerp(new_dir, steering_factor)#Blend with old direction to reduce jitter
	
	#print("after normalizing post rayZ", chosen_dir)


#Cast rays to find good directions (currently only includes "toward the player")
func set_interest(i: int)-> void:
	var space_state = get_world_2d().get_direct_space_state()
	var params = PhysicsRayQueryParameters2D.new()
	params.from = enemy_sprite.global_position
	params.to = enemy_sprite.global_position + ray_directions[i].rotated(rotation) * vision_range
	params.exclude = enemy_rids#[self]
	#params.collision_mask = 10
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var result = space_state.intersect_ray(params)

	if result:
	
		var collision_distance = result.position.distance_to(enemy_sprite.global_position)
		var max_player_interest = 0.9
		var max_drone_interest = 0.6
		var fade = 0.2
		var distance_factor = 1.0 - (collision_distance / vision_range)
		distance_factor = clamp(distance_factor, 0.0, 1.0)
	
		#print("Ray number: ", i,"interest_collider:	", result.collider, "		Distance: 	", collision_distance)
		#print(player_sighted_ray_flag)
		
		if result.collider.is_in_group("player"):
			interest[i] = max_player_interest * distance_factor
			interest[(i - 1 + num_rays) % num_rays] = max(((max_player_interest * distance_factor) - (fade * distance_factor)), interest[(i - 1 + num_rays) % num_rays])
			interest[(i + 1) % num_rays] = max(((max_player_interest * distance_factor) - (fade * distance_factor)), interest[(i + 1) % num_rays])
			interest[(i - 2 + num_rays) % num_rays] = max(((max_player_interest * distance_factor) - ((fade*2) * distance_factor)), interest[(i - 1 + num_rays) % num_rays])
			interest[(i + 2) % num_rays] = max(((max_player_interest * distance_factor) - ((fade*2) * distance_factor)), interest[(i + 1) % num_rays])
			player_sighted_ray_flag = true
			#print(result.collider.position)
		elif result.collider.is_in_group("drone") and player_sighted_ray_flag == false:
			interest[i] = max_drone_interest * distance_factor
			interest[(i - 1 + num_rays) % num_rays] = max(((max_drone_interest * distance_factor) - (fade * distance_factor)), interest[(i - 1 + num_rays) % num_rays])
			interest[(i + 1) % num_rays] = max(((max_drone_interest * distance_factor) - (fade * distance_factor)), interest[(i + 1) % num_rays])
			interest[(i - 2 + num_rays) % num_rays] = max(((max_drone_interest * distance_factor) - ((fade*2) * distance_factor)), interest[(i - 1 + num_rays) % num_rays])
			interest[(i + 2) % num_rays] = max(((max_drone_interest * distance_factor) - ((fade*2) * distance_factor)), interest[(i + 1) % num_rays])
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
	var max_wall_care = 35.0 #the distance we want to detect and avoid walls, 50 is very small, 23 is "you're on top of me", 35 seems to be about right for our tilesizes
	var space_state_d = get_world_2d().get_direct_space_state()
	var params_d = PhysicsRayQueryParameters2D.new()
	params_d.from = enemy_sprite.global_position
	params_d.to = enemy_sprite.global_position + ray_directions[i].rotated(rotation) * max_wall_care
	params_d.exclude = [self]
	#params_d.collision_mask = 10
	params_d.collide_with_areas = true
	params_d.collide_with_bodies = true
	
	var result = space_state_d.intersect_ray(params_d)
	
	if result:
	
		var collision_distance = result.position.distance_to(enemy_sprite.global_position)
		var max_danger = 0.9
		var fade = 0.2
		var distance_factor = 1.0 - (collision_distance / max_wall_care)
		distance_factor = clamp(distance_factor, 0.0, 1.0)
	
		#print("Ray number: ", i,"danger_collider:	", result.collider, result.collider.name, result.collider.name == "Player", "		Distance: 	", collision_distance)
		if result and result.collider.name != "Player":
			danger[i] = max_danger * distance_factor
			danger[(i - 1 + num_rays) % num_rays] = max(((max_danger * distance_factor) - (fade * distance_factor)), danger[(i - 1 + num_rays) % num_rays])
			danger[(i + 1) % num_rays] = max(((max_danger * distance_factor) - (fade * distance_factor)), danger[(i + 1) % num_rays])
			danger[(i - 2 + num_rays) % num_rays] = max(((max_danger * distance_factor) - ((fade*2) * distance_factor)), danger[(i - 2 + num_rays) % num_rays])
			danger[(i + 2) % num_rays] = max(((max_danger * distance_factor) - ((fade*2) * distance_factor)), danger[(i + 2) % num_rays])
			#print(ratio)
		elif result and result.collider.is_in_group("enemy"):
			danger[i] = max_danger * distance_factor
			danger[(i - 1 + num_rays) % num_rays] = max(((max_danger * distance_factor) - (0.2 * distance_factor)), danger[(i - 1 + num_rays) % num_rays])
			danger[(i + 1) % num_rays] = max(((max_danger * distance_factor) - (0.2 * distance_factor)), danger[(i + 1) % num_rays])
			danger[(i - 2 + num_rays) % num_rays] = max(((max_danger * distance_factor) - ((fade*2) * distance_factor)), danger[(i - 2 + num_rays) % num_rays])
			danger[(i + 2) % num_rays] = max(((max_danger * distance_factor) - ((fade*2) * distance_factor)), danger[(i + 2) % num_rays])
			#print("avoid other enemies")
		else:
			danger[i] = 0.0
			#print("no_danger")
	else:
		danger[i] = 0.0
	#print("Ray number: ", i,"		set_danger: 	", danger[i])


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		health -= 1
		#print("Hit! Health:", health)
	elif body.is_in_group("knife"):
		change_state("Enemy_Fallen")

	if health <= 0:
		#print("He dead Jim.")
		change_state("Enemy_KnockedOut")


func _on_jump_timer_timeout() -> void:
	jump_recharge = true
	#print("recharged!")
	random_dir = hare_off(ray_directions).rotated(rotation)
	#print("chose random direction", random_dir)

func hare_off(vectors: Array[Vector2]) -> Vector2:
	var rngH = RandomNumberGenerator.new()
	rngH.randomize()
	var random = rngH.randi_range(0, vectors.size() - 1)
	return vectors[random]
