extends Boss_State

class_name EnemyFollowState
 
func transition():
	if ray_cast.is_colliding() and owner.death == false:
		get_parent().change_state("Shoot")
	elif  owner.death == true:
		get_parent().change_state("Death")
 
func enter():
	super.enter()
	owner.set_physics_process(true)
 
func exit():
	super.exit()
	owner.set_physics_process(false)
