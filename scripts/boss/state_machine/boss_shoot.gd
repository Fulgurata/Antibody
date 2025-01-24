extends Boss_State
class_name ShootState
 
const boss_slime = preload("res://scenes/boss/boss_slime.tscn")
@onready var timer = $Timer
 
func transition():
	if not ray_cast.is_colliding():
		if owner.health == 10:
			get_parent().change_state("Follow")
		else:
			get_parent().change_state("Dash")
 
func enter():
	super.enter()
	timer.start()
 
func exit():
	super.exit()
	timer.stop()
 
 
func _on_timer_timeout():
	shoot()
 
func shoot():
	var bullet = boss_slime.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = global_position
	bullet.rotation = global_rotation
 
