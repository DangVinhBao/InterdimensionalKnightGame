extends "res://Environment/ElementalStatus/Status.gd"

func _init(t, dur, lv).(t, dur, lv):
	type = Utils.STATUS.POISON
	tick_time = 1
	base_damage = 1

func combine(status, delta):
	if status.type == Utils.STATUS.POISON:
		#extent duration
		if level == status.level:
			if duration < status.duration:
				duration = status.duration
		else:
			duration += delta
		#upgrade level if combine with stronger poison
		if level < status.level:
			#erase previous start effect
			rev_effect.call_func()
			duration = (duration*level + status.duration*status.level)/(level+status.level)
			level = status.level
			#reapply effect
			start_effect.call_func()
		return self
		pass
	#no match type
	return false
	pass
#update
func update(delta):
	.update(delta)
	timer += delta
	if timer >= tick_time:
		tick_effect.call_func()
		timer = 0
	pass
#effect happen when the status is added into array or combined 
func start_effect():
	pass
#reverse the effect happen at the start
func rev_start_effect():
	pass

#call when timer == tick_time
func tick_effect():
	.tick_effect()
	target.current_health -= 1
	pass