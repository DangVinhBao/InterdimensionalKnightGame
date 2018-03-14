extends Node2D

onready var flip = get_parent()
onready var user = flip.get_parent()

export var damage = 0
export var push_back_force = Vector2()
export var status = ""

var direction = 1
#current attack state
var cur_atk_state;

func _ready():
	pass

func _init():
	pass

#what player do when press atk1 button decide in weapon
#run first when atk1 is pressed, changing from other state 
#that is not an atk state
#use to check for combination of buttons pressed
func state_atk1_init():
	pass
func state_atk2_init():
	pass
func state_atk1_air_init():
	pass
func state_atk2_air_init():
	pass
#update func run constantly during state 
func update():
	cur_atk_state.update()
	pass

func stop_atking():
	user.state_machine.pop_state()
	pass
	
#no need for switch to wind up state, always start with it
#switch cur atk state
func switch_atk_state_attack():
	cur_atk_state.switch_attack_func()
	pass

func switch_atk_state_callback():
	cur_atk_state.switch_callback_func()
	pass

##air movement
func air_move(user):
	if user.btn_left.check() == 2:
		user.direction = -1
		user.move( user.direction * user.max_run_speed, user.accerleration/10)
	elif user.btn_right.check() == 2:
		user.direction = 1
		user.move( user.direction * user.max_run_speed, user.accerleration/10)
	else:
		user.move(0, user.accerleration)
	pass
	
