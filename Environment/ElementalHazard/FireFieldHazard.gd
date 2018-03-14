extends Area2D

export var level = 1
export var duration = 3
export var lifetime = 60
var areas

func _ready():
	set_process(true)
	pass

func _process(delta):
	if lifetime <= 0:
		queue_free()
		return
	lifetime -= delta
	areas = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("HURTBOX"):
			area.get_parent().apply_status(Utils.STATUS.FIRE, duration, level)
	pass
	
func apply_status(status, duration, lv):
	if status == Utils.STATUS.OIL:
		if level <= lv:
			level = lv+1;
	pass
func take_damage(dmg, direction, force):
	pass

