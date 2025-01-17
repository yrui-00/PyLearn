# game_saver.gd - Autoload this script
extends Node
const SAVE_PATH = "user://player_save.tres"

func save_game(player: Player) -> void:
	var save_data = GameData.new()
	
	# Save player state
	save_data.position = player.position
	save_data.score = player.score_counter
	save_data.player_name = player.name_label.text
	save_data.last_direction = player.last_direction
	
	# Save inventory if it exists
	if player.inventory:
		save_data.inventory_items = player.inventory.get_items()  # Assuming inventory has this method
	
	# Save to disk
	var error = ResourceSaver.save(save_data, SAVE_PATH)
	if error != OK:
		print("An error occurred while saving the game. Error code: ", error)

func load_game(player: Player) -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return
		
	var save_data = ResourceLoader.load(SAVE_PATH) as GameData
	if not save_data:
		print("Failed to load save file.")
		return
	
	# Load player state
	player.position = save_data.position
	player.set_score(save_data.score)
	player.name_label.text = save_data.player_name
	player.last_direction = save_data.last_direction
	
	# Load inventory if it exists
	if player.inventory and save_data.inventory_items.size() > 0:
		player.inventory.load_items(save_data.inventory_items)  # Assuming inventory has this method
