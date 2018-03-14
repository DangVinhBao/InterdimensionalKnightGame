extends Node2D

func _on_Area2D_body_enter(body):
	if body.get_name() == "player":
		get_tree().change_scene("res://Stages/end_game.tscn")
