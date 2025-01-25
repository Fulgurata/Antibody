extends Boss_State

class_name DashState
 
@onready var timer = $Timer
var times_up = false

func transition():
	if ray_cast.is_colliding() and times_up == true and owner.death == false:
		get_parent().change_state("BulletHell")
	elif  owner.death == true:
		get_parent().change_state("Dead")
 
func dash():
	var tween = get_tree().create_tween()
	tween.tween_property(owner, "position", player.position, 0.75)
	times_up = true
 
func _on_timer_timeout():
	dash()
 
func enter():
	times_up = false
	super.enter()
	timer.start()
 
func exit():
	super.exit()
	timer.stop()
