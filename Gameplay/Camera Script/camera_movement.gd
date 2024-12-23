extends Camera2D

# Define the size of each camera zone (the area before the camera moves)
var camera_zone_size = Vector2(315, 185)  # Adjust to desired camera area size
var current_camera_zone = Vector2.ZERO  # Keeps track of the current camera zone

# Reference to the player node
@onready var player = get_node("/root/Level01/Player")

func _ready():
	# Make this camera the current active camera
	make_current()

	# Initialize camera position based on the player's initial position
	current_camera_zone = get_current_camera_zone()
	position = get_camera_position(current_camera_zone)

# Function to calculate the current camera zone based on player position
func get_current_camera_zone() -> Vector2:
	# Return the zone based on the player's position
	return Vector2(
		floor(player.position.x / camera_zone_size.x),
		floor(player.position.y / camera_zone_size.y)
	)

# Function to calculate the camera's position based on the camera zone
func get_camera_position(zone: Vector2) -> Vector2:
	# Center the camera to the middle of the zone
	return zone * camera_zone_size + camera_zone_size / 2

# Check if the player leaves the current camera zone and update the camera
func _process(_delta):
	var new_camera_zone = get_current_camera_zone()

	# Check if the player has moved to a new zone
	if new_camera_zone != current_camera_zone:
		# Update the current zone to the new one
		current_camera_zone = new_camera_zone
		
		# Move the camera smoothly to the new zone position
		# You can use tweening or interpolation for smooth transitions
		position = get_camera_position(current_camera_zone)
