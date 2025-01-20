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

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("next_weapon"):
		current_weapon_index = (current_weapon_index + 1) % weapons.size()
		reset_fire_rate()
	elif Input.is_action_just_pressed("previous_weapon"):
		current_weapon_index = (current_weapon_index - 1 + weapons.size()) % weapons.size()
		reset_fire_rate()

	if Input.is_action_just_pressed("shooting") or (weapons[current_weapon_index] == "assault_rifle" and Input.is_action_pressed("shooting")):
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
	var bullet_instance = BULLET.instantiate()
	bullet_instance.global_position = muzzle.global_position
	var facing_direction = Vector2(cos(player.rotation), sin(player.rotation))
	bullet_instance.direction = facing_direction.normalized()
	get_tree().root.add_child(bullet_instance)

func fire_shotgun() -> void:
	print("firing shotgun")
	var num_bullets = 4
	var spread_angle = deg_to_rad(10)
	var angle_step = spread_angle / (num_bullets - 1)

	for i in range(num_bullets):
		var bullet_instance = BULLET.instantiate()
		bullet_instance.global_position = muzzle.global_position
		var bullet_rotation = player.rotation - (spread_angle / 2) + (i * angle_step)
		var bullet_direction = Vector2(cos(bullet_rotation), sin(bullet_rotation))
		bullet_instance.direction = bullet_direction
		get_tree().root.add_child(bullet_instance)

func fire_assault_rifle() -> void:
	var bullet_instance = BULLET.instantiate()
	bullet_instance.global_position = muzzle.global_position
	var facing_direction = Vector2(cos(player.rotation), sin(player.rotation))
	bullet_instance.direction = facing_direction.normalized()
	get_tree().root.add_child(bullet_instance)
	
	
func give_ammo_dev() -> void:
	var current_weapon = weapons[current_weapon_index]
	magazine_ammo[current_weapon] = max_magazine_ammo[current_weapon]
