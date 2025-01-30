extends Boss_State

class_name FollowState
 
func transition():
	if ray_cast.is_colliding() and owner.death == false:
		get_parent().change_state("Shoot")
	elif  owner.death == true:
		get_parent().change_state("Dead")
 
func enter():
	$"../../AnimatedSprite2D".play("Boss_walk")
	super.enter()
	owner.set_physics_process(true)
 
func exit():
	super.exit()
	owner.set_physics_process(false)
