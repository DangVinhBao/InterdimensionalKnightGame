extends Control

onready var Save = preload("res://Save.gd")

func _ready():
	game.hide_hud()
	set_process(true)
	

func _on_play_button_pressed():
	get_tree().set_pause(false)
	if get_node("/root/game/HUD/Control").is_hidden():
		game.show_hud()
	Save.load_game()
	get_tree().change_scene("res://Stages/TuanWorld.tscn")

	
	game.emit_signal("play_pressed")

	
	#run script Save.gd