extends Button

onready var Save = get_node('/root/Save')

func _on_LoadButton_pressed():
#	get_tree().change_scene("res://Stages/BaoWorld.tscn")
	Save.load_game()