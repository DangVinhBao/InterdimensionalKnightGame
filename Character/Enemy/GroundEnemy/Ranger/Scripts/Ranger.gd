extends "res://Character/Enemy/GroundEnemy/GroundEnemy.gd"

# preload classes
var WanderBehavior  = preload("res://Character/Enemy/GroundEnemy/AIBehaviors/WanderBehavior.gd")
var PursuitBehavior = preload("res://Character/Enemy/GroundEnemy/AIBehaviors/PursuitBehavior.gd")
var ArrowScene      = preload("res://Character/Enemy/GroundEnemy/Ranger/arrow.tscn")

export var PROJECTILE_SPEED = 600

# STATES
const STATE = { 
	WANDER = "wander",
	PURSUIT = "pursuit",
	ATTACK = "attack",
	HURT = "hurt"
}

# READY
func _ready():
	WanderBehavior  = WanderBehavior.new(self)
	PursuitBehavior = PursuitBehavior.new(self)
	state_machine.push_state(STATE.WANDER)
	pass

func _draw():
	if DEBUG_MODE:
		draw_circle(Vector2(0,0), PURSUIT_RANGE, Color(0, 1, 0, 0.1))
		var prev_item = get_pos()
		for item in PursuitBehavior.traces:
			draw_line(prev_item-get_pos(), item-get_pos(), Color(0,0,1), 2)
			draw_circle(item-get_pos(), 10, Color(0,0,1))
			prev_item = item
	pass

# Override
# Take damage when being attacked
func take_damage(damage, direction, push_back_force):
	.take_damage(damage, direction, push_back_force)
	state_machine.pop_state()
	state_machine.push_state(STATE.HURT)
	run_anim()
	pass

## Animation handling
func run_anim():
	current_state = state_machine.get_current_state()
	
	if current_state == STATE.WANDER:
		if WanderBehavior.is_wandering():
			play_loop_anim("wander")
		else:
			idle()
	elif current_state == STATE.PURSUIT:
		play_loop_anim("pursuit")
	elif current_state == STATE.HURT:
		anim.stop()
		anim.play("hurt")
	elif current_state == STATE.ATTACK:
		anim.stop()
		anim.play(STATE.ATTACK)
	
	pass

# WANDER STATE ------------------------------------------------------------------------
# WANDERING and IDLING
func wander():
	WanderBehavior.wander()
	run_anim()
	
	## EXIT
	# WANDER -> PURSUIT
	if player_dt.is_colliding():
		WanderBehavior.exit()
		state_machine.pop_state()
		state_machine.push_state(STATE.PURSUIT)
	
	pass


# PURSUIT STATE -----------------------------------------------------------------------
# PURSUIT the PLAYER when they are detected
func pursuit():
	PursuitBehavior.pursuit()
	run_anim()
	
	## EXIT
	# PURSUIT -> WANDER
	if is_target_out_of_range(PURSUIT_RANGE, OS.get_window_size().y):
		PursuitBehavior.exit()
		state_machine.pop_state()
		state_machine.push_state(STATE.WANDER)
	
	## EXIT
	# PURSUIT -> ATTACK
	if attack_dt.is_colliding() and ground_check():
		PursuitBehavior.exit()
		state_machine.push_state(STATE.ATTACK)
	
	pass


# HIT STATE -----------------------------------------------------------------------------
# When SELF is take_damage
func hurt():
	## EXIT
	# HURT -> PURSUIT
	if ground_check() and not anim.is_playing():
		time = ATTACK_INTERVAL + att_time
		state_machine.pop_state()
		state_machine.push_state(STATE.PURSUIT)
	pass


# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attack():
	time = time + Utils.fixed_delta
	
	# Start Attack condition
	if time >= ATTACK_INTERVAL + att_time:
		run_anim()
		time = 0
	elif time > att_time:
		idle()
		direction = sign(target.get_pos().x - get_pos().x)
	
	## EXIT
	# ATTACK -> previous STATE
	if is_target_out_of_range(ATTACK_RANGE*1.5, OS.get_window_size().y) or not ground_check():
		time = ATTACK_INTERVAL + att_time
		state_machine.pop_state()
	pass

func fire():
	var arrow = ArrowScene.instance()
	arrow.set_pos(get_global_pos() + Vector2(100,0)*direction)
	arrow.direction = direction
	arrow.projectile_range = PURSUIT_RANGE
	arrow.projectile_speed = PROJECTILE_SPEED
	get_parent().add_child(arrow)
	pass

