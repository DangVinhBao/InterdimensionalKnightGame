extends "res://Character/Enemy/AirEnemy/AirEnemy.gd"

var SteeringBehavior = preload("res://Character/Enemy/AirEnemy/AIBehaviors/SteeringBehavior.gd")

onready var hitbox = get_node("hitbox")
onready var alert_sign = flip.get_node("alert_sign")
onready var particles = flip.get_node("particles")

export var EXPLOSION_RANGE = 400
export (float) var CHARGE_UP_TIME = 1

# STATES
const STATE = {
	FLYING = "flying",
	PURSUIT = "pursuit",
	EXPLODE = "explode",
	ALERT = "alert"
}

func _ready():
	._ready()
	hitbox.get_node("shape").get_shape().set_radius(EXPLOSION_RANGE)
	detect_area.get_node("shape").get_shape().set_radius(DETECTION_RANGE)
	SteeringBehavior = SteeringBehavior.new(self)
	state_machine.push_state(STATE.FLYING)
	particles.set_emitting(false)
	pass

## Animation handling
func run_anim():
	current_state = state_machine.get_current_state()
	
	if current_state == STATE.FLYING:
		play_loop_anim(STATE.FLYING)
	elif current_state == STATE.PURSUIT:
		if not anim.get_current_animation() == STATE.PURSUIT:
			anim.play(STATE.PURSUIT)
	elif current_state == STATE.EXPLODE:
		pass
	elif current_state == STATE.ALERT:
		anim.stop()
	pass


# WANDER STATE ------------------------------------------------------------------------
func flying():
	run_anim()
	pass

## EXIT
# FLYING -> ALERT
func _on_detect_area_body_enter( body ):
	if body.is_in_group("PLAYER") and state_machine.get_current_state() == STATE.FLYING:
		state_machine.push_state(STATE.ALERT)
	pass # replace with function body


# ALERT STATE ------------------------------------------------------------------------
func alert():
	run_anim()
	direction = sign(target.get_pos().x - get_pos().x)
	alert_sign.set_hidden(false)
	var animation = alert_sign.get_node("anim")
	if not animation.is_playing():
		animation.play("alert")
	yield(animation, "finished")
	alert_sign.set_hidden(true)
	
	## EXIT
	# ALERT -> PURSUIT
	state_machine.pop_state()
	state_machine.push_state(STATE.PURSUIT)
	pass


# PURSUIT STATE ------------------------------------------------------------------------
func pursuit():
	run_anim()
	SteeringBehavior.steer(target)
	direction = sign(target.get_pos().x - get_pos().x)
	pass

## EXIT
# PURSUIT -> EXPLODE
func _on_hurtbox_body_enter( body ):
	if body.is_in_group("PLAYER") and state_machine.get_current_state() == STATE.PURSUIT:
		particles.set_emitting(false)
		state_machine.push_state(STATE.EXPLODE)
	pass # replace with function body


# EXPLODE STATE ------------------------------------------------------------------------
func explode():
	set_linear_velocity(Vector2(0,0))
	time = time + Utils.fixed_delta
	
	if time >= CHARGE_UP_TIME:
		die_exploding()
	else:
		play_loop_anim("charging")
	pass

func die_exploding():
	set_process(false)
	set_fixed_process(false)
	hurtbox.queue_free()
	physics_box.queue_free()
	anim.play("explode")
	if hitbox.overlaps_area(target.get_node("hurtbox")):
		var direction = sign(target.get_pos().x - get_pos().x)
		target.take_damage(ATTACK_DMG, direction, KNOCKBACK_FORCE)
	yield(anim, "finished")
	queue_free()
	pass
