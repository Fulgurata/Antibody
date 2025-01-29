extends Boss_State

class_name EnemyShootState

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
const boss_slime = preload("res://scenes/boss/boss_slime.tscn")
@onready var timer = $Timer

func transition():
	if not ray_cast.is_colliding() and owner.death == false:
		var next_state = "Follow"
		get_parent().change_state(next_state)
	elif  owner.death == true:
		get_parent().change_state("Death")
	

func enter():
	super.enter()
	timer.start()
	
 
func exit():
	super.exit()
	timer.stop()


func _on_timer_timeout():
	shoot()


func shoot():
	sprite.play("Windup")
	await sprite.animation_finished
	if owner.death == false:
		var bullet = boss_slime.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = global_position
		bullet.rotation = global_rotation
