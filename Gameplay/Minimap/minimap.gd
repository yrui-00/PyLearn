extends CanvasLayer

@export var player_path: NodePath
@export var tilemap_path: NodePath
@export var tile_size: Vector2 = Vector2(64, 64)  # Default tile size, change if needed

@onready var player = get_node(player_path) as CharacterBody2D
@onready var tilemap = get_node(tilemap_path) as TileMap
@onready var sub_viewport = $SubViewportContainer/SubViewport

var minimap_tilemap
var minimap_player

func _ready():
	# Ensure the player and tilemap are properly initialized
	if not player or not tilemap:
		print("Player or TileMap is not set!")
		return

	# Duplicate the TileMap for the minimap
	minimap_tilemap = tilemap.duplicate()
	if minimap_tilemap:
		sub_viewport.add_child(minimap_tilemap)
	else:
		print("Failed to duplicate tilemap!")

	# Duplicate the player for the minimap
	minimap_player = player.duplicate()
	if minimap_player:
		sub_viewport.add_child(minimap_player)
		# Hide the original player in the minimap view
		player.visible = true
	else:
		print("Failed to duplicate player!")

func _process(delta):
	# Ensure minimap_player exists before accessing its properties
	if minimap_player and player:
		# Update the minimap player's position to follow the main player
		minimap_player.position = player.position

	# If necessary, move the minimap's camera view to always follow the player
	if minimap_tilemap:
		var offset = -player.position + Vector2(sub_viewport.size.x, sub_viewport.size.y) / 2
		
		# Get the size of the tilemap in pixels (used for limiting minimap camera movement)
		var map_size = Vector2(tilemap.get_used_rect().size.x, tilemap.get_used_rect().size.y) * tile_size  # Convert to Vector2 and multiply
		
		# Clamping the minimap camera within the bounds of the map size
		offset.x = clamp(offset.x, -map_size.x + sub_viewport.size.x, 0)
		#offset.y = clamp(offset.y, -map_size.y + sub_viewport.size.y, 0)
		
		# Apply the calculated offset to the minimap's tilemap
		minimap_tilemap.position = offset
