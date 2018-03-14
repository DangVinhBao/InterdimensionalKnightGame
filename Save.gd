# Stores, saves and loads game Settings in an ini-style file
extends Node

const SAVE_PATH = "res://save.json"

func _ready():
	var dir = Directory.new()
	dir.remove("res://save.json")
#	load_game()
		

func save_game():
	# Open the existing save file or create a new one in write mode
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

	# All the nodes to save are in a group called "persistent"
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group("persistent")
	for node in nodes_to_save:
		# The key to access each data dictionary is the node's path, so we can retrieve the node in load_game
		save_dict[node.get_path()] = node.get_state()
	
	# converts the entire dictionary to a JSON string
	save_file.store_line(save_dict.to_json())
	save_file.close()

#LOAD function
func load_game():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		print("The save file does not exist.")
		return
	save_file.open(SAVE_PATH, File.READ)

	#convert the JSON back to a dictionary
	var data = {}
	data.parse_json(save_file.get_as_text())
	
	# The dict keys on the first level are paths to the nodes
	for node_path in data.keys():
		var node_data = data[node_path]
		get_node(node_path).load_state(node_data)
