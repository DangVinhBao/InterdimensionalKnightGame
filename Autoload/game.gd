extends Node

signal pause_pressed 
signal resume_pressed


onready var hud_scene = preload("res://HUD/HUD.tscn")
#onready var ui = preload("res://Menu/ui.tscn")

func _ready():
	var hud = hud_scene.instance()
	add_child(hud)
#	var S = preload("res://Save.gd")
#	print("hello test")
	set_process_input(true)
	
func hide_hud():
	get_node("/root/game/HUD/Control").hide()

func show_hud():
	get_node("/root/game/HUD/Control").show()

