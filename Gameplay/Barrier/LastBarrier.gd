extends Area2D

@onready var player = $"../../Player" # Ensure this path is correct
@onready var static_body = $StaticBody2D
@onready var collision_shape = static_body.get_node("CollisionShape2D")
var check_timer = null

func _ready():
	# Set up a timer to check for changes periodically
	check_timer = Timer.new()
	add_child(check_timer)
	check_timer.wait_time = 0.1  # Check every 0.1 seconds
	check_timer.connect("timeout", Callable(self, "_on_timeout"))  # Correct connection using Callable
	check_timer.start()

	# Initialize the collision state based on forestkey value
	update_collision()

# Called when the player enters the Area2D (i.e., approaches the wall)
func _on_body_entered(body):
	if body == player:
		# Ensure the correct collision state based on forestkey value
		update_collision()

# Function to update collision based on forestkey state
func update_collision():
	if State.lastkey == "true":
		# Allow the player to pass by disabling collision
		static_body.set_collision_layer(0)  # No collision layer
		static_body.set_collision_mask(0)   # No collision mask
	else:
		# Block the player by enabling collision
		static_body.set_collision_layer(1)  # Default collision layer (1)
		static_body.set_collision_mask(1)   # Default collision mask (1)

# Timer callback function to periodically check the forestkey value
func _on_timeout():
	update_collision()
