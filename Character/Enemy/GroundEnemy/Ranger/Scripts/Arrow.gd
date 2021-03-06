extends KinematicBody2D

onready var flip = get_node("flip")
onready var anim = flip.get_node("sprite/anim")
onready var hitbox = flip.get_node("hitbox")

var parent
var pivot
var direction
var projectile_range
var projectile_speed
var distance = 0
var velocity = Vector2()

func init_variables(parent):
	self.parent = parent
	direction = parent.direction
	projectile_range = parent.PURSUIT_RANGE
	projectile_speed = parent.PROJECTILE_SPEED
	pivot = parent.fire_position.get_pos()
	pass

func _ready():
	set_process(true)
	anim.play("flying")
	pivot.x = pivot.x * direction
	set_pos(pivot + parent.get_pos())
	pass

func _process(delta):
	if distance >= projectile_range:
		destroy()
	
	velocity = Vector2(projectile_speed * direction, 0) * delta
	distance = distance + projectile_speed * delta
	move(velocity)
	pass

func _on_hitbox_area_enter( area ):
	if area.is_in_group("PLAYER"):
		parent.target.take_damage(parent.ATTACK_DMG, direction, parent.KNOCKBACK_FORCE)
		destroy()
	pass # replace with function body

func destroy():
	set_process(false)
	hitbox.queue_free()
	anim.play("destroy")
	yield(anim, "finished")
	queue_free()
	pass

