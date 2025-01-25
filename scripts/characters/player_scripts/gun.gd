#gun script
extends Node2D

@onready var player: CharacterBody2D = $".."

var BULLET = preload("res://scenes/characters/player/bullet.tscn")

@onready var muzzle: Marker2D = $muzzle
#@onready var camera: Camera2D = $Camera2D

var weapons = ["gun", "shotgun", "assault_rifle"]
var current_weapon_index: int = 0

var gun_fire_rate: float = 0.3
var shotgun_fire_rate: float = 0.8
var assault_rifle_fire_rate: float = 0.3
var last_fire_time: float = 0

var magazine_ammo = {"gun": 15, "shotgun": 6, "assault_rifle": 30}
var max_magazine_ammo = {"gun": 15, "shotgun": 6, "assault_rifle": 30}
var reserve_ammo = {"gun": 7, "shotgun": 4, "assault_rifle": 30}
var reload_times = {"gun": 1.5, "shotgun": 2.5, "assault_rifle": 2.0}
var is_reloading: bool = false
var reload_time_remaining: float = 0.0
#Add a deviation factor for bullet inaccuracy
var gun_deviation: float = deg_to_rad(5)
var assault_rifle_deviation: float = deg_to_rad(1.5)
var shotgun_pellet_deviation: float = deg_to_rad(2)
#Recoil Adjustments
var assault_rifle_slow_factor: float = 0.3  # Increased slowdown factor for assault rifle
var shotgun_recoil_force: float = 400.0  # Increased recoil force for shotgun
var assault_rifle_firing: bool = false
#neW RECOIL VARIABLES
var recoil_time_remaining: float = 0.0
var recoil_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	if player.has_signal("ammo_pickup"):
		player.connect("ammo_pickup", Callable(self, "_on_ammo_pickup"))

func _process(delta: float) -> void:
	if is_reloading:
		reload_time_remaining -= delta
		if reload_time_remaining <= 0:
			finish_reload()
			is_reloading = false
			
	if recoil_time_remaining > 0:
		recoil_time_remaining -= delta
		player.velocity = recoil_direction  # Apply inverted movement
	if recoil_time_remaining <= 0:
		player.velocity = Vector2.ZERO  # Reset velocity after recoil
	
	if Input.is_action_just_pressed("next_weapon"):
		current_weapon_index = (current_weapon_index + 1) % weapons.size()
		reset_fire_rate()
	elif Input.is_action_just_pressed("previous_weapon"):
		current_weapon_index = (current_weapon_index - 1 + weapons.size()) % weapons.size()
		reset_fire_rate()

	if not is_reloading and (Input.is_action_just_pressed("shooting") or (weapons[current_weapon_index] == "assault_rifle" and Input.is_action_pressed("shooting"))):
		var current_time = Time.get_ticks_msec() / 1000.0
		var fire_rate = get_fire_rate()
		var current_weapon = weapons[current_weapon_index]

		if current_time - last_fire_time >= fire_rate and magazine_ammo[current_weapon] > 0:
			match current_weapon:
				"gun":
					fire_gun()
				"shotgun":
					fire_shotgun()
				"assault_rifle":
					fire_assault_rifle()
			magazine_ammo[current_weapon] -= 1
			last_fire_time = current_time

	if weapons[current_weapon_index] == "assault_rifle" and Input.is_action_just_released("shooting"):
		stop_assault_rifle_slowdown()
	if Input.is_action_just_pressed("reload") and not is_reloading:
		reload_weapon()
	if Input.is_action_just_pressed("give_ammo_dev"):
		give_ammo_dev()

func reset_fire_rate() -> void:
	last_fire_time = 0

func get_fire_rate() -> float:
	match weapons[current_weapon_index]:
		"gun":
			return gun_fire_rate
		"shotgun":
			return shotgun_fire_rate
		"assault_rifle":
			return assault_rifle_fire_rate
	return 0.5

func fire_gun() -> void:
	$PistolFire.play()
	var bullet_instance = BULLET.instantiate()
	bullet_instance.global_position = muzzle.global_position
	var deviation = randf_range(-gun_deviation, gun_deviation)
	var facing_direction = Vector2(cos(player.rotation + deviation), sin(player.rotation + deviation))
	bullet_instance.direction = facing_direction.normalized()
	get_tree().root.add_child(bullet_instance)

func fire_shotgun() -> void:
	#print("firing shotgun")
	$ShotgunFire.play()
	var num_bullets = 4
	var spread_angle = deg_to_rad(10)
	var angle_step = spread_angle / (num_bullets - 1)

	for i in range(num_bullets):
		var bullet_instance = BULLET.instantiate()
		bullet_instance.global_position = muzzle.global_position
		var base_rotation = player.rotation - (spread_angle / 2) + (i * angle_step)
		var deviation = randf_range(-shotgun_pellet_deviation, shotgun_pellet_deviation)
		var bullet_rotation = base_rotation + deviation
		var bullet_direction = Vector2(cos(bullet_rotation), sin(bullet_rotation))
		bullet_instance.direction = bullet_direction
		get_tree().root.add_child(bullet_instance)
#Detect current movement direction and invert it
	if player.velocity.length() > 0:
		recoil_direction = -player.velocity.normalized() * shotgun_recoil_force
	else:
		recoil_direction = (player.position - get_global_mouse_position()).normalized() * shotgun_recoil_force

		recoil_time_remaining = 0.1  # Apply recoil for 0.1 seconds
		apply_recoil()

func fire_assault_rifle() -> void:
	$RilfeFire.play()
	var bullet_instance = BULLET.instantiate()
	bullet_instance.global_position = muzzle.global_position
	var deviation = randf_range(-assault_rifle_deviation, assault_rifle_deviation)
	var facing_direction = Vector2(cos(player.rotation + deviation), sin(player.rotation + deviation))
	bullet_instance.direction = facing_direction.normalized()
	get_tree().root.add_child(bullet_instance)

	if not assault_rifle_firing:
		assault_rifle_firing = true
		player.max_speed *= assault_rifle_slow_factor
	
func stop_assault_rifle_slowdown() -> void:
	if assault_rifle_firing:
		assault_rifle_firing = false
		player.max_speed = player.normal_speed

func reload_weapon() -> void:
	$Reload.play()
	is_reloading = true
	reload_time_remaining = reload_times[weapons[current_weapon_index]]
	
func finish_reload() -> void:
	var current_weapon = weapons[current_weapon_index]
	var missing_ammo = max_magazine_ammo[current_weapon] - magazine_ammo[current_weapon]
	var ammo_to_reload = min(missing_ammo, reserve_ammo[current_weapon])
	magazine_ammo[current_weapon] += ammo_to_reload
	reserve_ammo[current_weapon] -= ammo_to_reload
	
func give_ammo_dev() -> void:
	var current_weapon = weapons[current_weapon_index]
	magazine_ammo[current_weapon] = max_magazine_ammo[current_weapon]

func _on_ammo_pickup(ammo_type: String, ammo_amount: int) -> void:
	if ammo_type in reserve_ammo:
		reserve_ammo[ammo_type] += ammo_amount
		print("Picked up", ammo_amount, "ammo for", ammo_type)

func apply_recoil() -> void:
	player.velocity += recoil_direction  # Apply immediate recoil force
