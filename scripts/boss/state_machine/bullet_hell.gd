extends Boss_State

class_name BulletHell

const boss_bullet = preload("res://scenes/boss/boss_bullet.tscn")
@onready var timer = $Timer
@onready var rotater = $Rotater
@onready var cool_down: Timer = $"../../CoolDown"

const rotate_speed := 100
const shooter_timer_wait_time = 0.2
const spawn_point_count = 4
const radius = 100
var times_up = false

func transition():
	var distance_to_player = owner.global_position.distance_to(player.global_position)
	if times_up == true and owner.death == false:
		if distance_to_player < owner.MIN_DISTANCE:
			get_parent().change_state("Laser")
		elif distance_to_player > owner.MIN_DISTANCE: 
			get_parent().change_state("Dash")
	elif  owner.death == true:
		get_parent().change_state("Dead")

func enter():
	super.enter()
	cool_down.start()
	timer.start()
	times_up = false
	var step = 2 * PI / spawn_point_count

	for i in range(spawn_point_count):
		print("Im working")
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

func exit():
	super.exit()
	timer.stop()
	cool_down.stop()
 
func _process(delta: float) -> void:
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func _on_timer_timeout():
	shoot()
 
func shoot():
	if owner.death == false:
		$"../../AnimatedSprite2D".play("Boss_spin")
		for s in rotater.get_children():
			var bullet = boss_bullet.instantiate()
			get_tree().root.add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation


func _on_cool_down_timeout() -> void:
	times_up = true
