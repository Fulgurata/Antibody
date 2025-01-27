extends Boss_State

class_name EnemyIdleState
 
func transition():
	
	if ray_cast.is_colliding() and owner.death == false:
		get_parent().change_state("Shoot")
	elif  owner.death == true:
		get_parent().change_state("Death")
