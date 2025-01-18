extends Node
class_name SaveSystem

const SAVE_PATH = "user://game_save.tres"

# Static function to save the game
static func save_game(position: Vector2, score: int, player_name: String, inventory: Inventory) -> void:
	var game_data = GameData.new()
	
	# Set the data
	game_data.position = position
	game_data.score = score
	game_data.player_name = player_name
	# Store item IDs instead of the actual items
	game_data.inventory_item_ids = inventory.get_item_ids() if inventory else []
	
	# Save the resource to file
	var error = ResourceSaver.save(game_data, SAVE_PATH)
	if error != OK:
		print("An error occurred while saving the game. Error code: ", error)
	else:
		print("Game saved successfully!")

static func load_game() -> GameData:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found!")
		return null
		
	var game_data = ResourceLoader.load(SAVE_PATH) as GameData
	if game_data == null:
		print("Error loading save file!")
		return null
	
	return game_data
