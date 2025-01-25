extends Boss_State

class_name IdleState
 
func transition():
	
	if ray_cast.is_colliding() and owner.death == false:
		get_parent().change_state("Shoot")
	elif  owner.death == true:
		get_parent().change_state("Dead")
