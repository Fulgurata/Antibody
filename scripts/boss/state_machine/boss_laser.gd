extends Boss_State

const laser_scene = preload('res://scenes/boss/boss_laser.tscn')
@export var grid_size: Vector2 = Vector2(6, 6)  # Number of lasers (rows, columns)
@export var laser_spacing: float = 200  # Space between lasers
@export var attack_duration: float = 5.0  # Total duration of the attack
@export var warning_duration: float = 1.0  # Warning duration before firing

var laser_positions: Array[Vector2] = []
var timer: Timer
var shot_laser = false

func transition():
	print("Transition function called. shot_laser =", shot_laser)
	if shot_laser:
		get_parent().change_state("Follow")
 
func enter():
	print("entering laser state")
	shot_laser = false
	calculate_laser_positions()
	spawn_lasers()
	timer = Timer.new()
	timer.wait_time = attack_duration
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	super.enter()
	

func exit():
	owner.set_physics_process(false)
	print("hello world")
	if timer:
		timer.stop()
		timer.queue_free()
		timer = null
	for laser in get_tree().get_nodes_in_group("lasers"):
		laser.queue_free()
	super.exit()

func _on_timer_timeout():
	print("Timer finished. Cleaning up lasers and setting up transition.")
	for laser in get_tree().get_nodes_in_group("lasers"):
		laser.queue_free()

	if timer:
		timer.stop()
		timer.queue_free()
		timer = null
	shot_laser = true

func calculate_laser_positions():
	laser_positions.clear()
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var pos = Vector2(x * laser_spacing, y * laser_spacing)
			laser_positions.append(pos)

func spawn_lasers():
	for pos in laser_positions:
		var laser = laser_scene.instantiate()
		laser.position = global_position + pos - grid_size / 2 * laser_spacing
		laser.rotation = 0  # Adjust rotation as needed
		laser.add_to_group("lasers")
		get_tree().root.add_child(laser)
		laser.setup_laser(laser.position, laser.rotation)   # Call laser setup
