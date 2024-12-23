extends Area2D

var control_node = null
var video_player = null
@onready var player =  $"../../Player" # Adjust path to your player node
@onready var camera =  $"../../Camera2D" # Adjust path to your Camera2D node
@onready var canvas_layer = $"../Crdts" # Adjust path to your CanvasLayer node
@onready var ui_follow_player = $"../Crdts/ControlCrdts"  # Adjust path to your Node2D or Control node under CanvasLayer

# Flag to ensure the area is entered only once
var has_entered = false

func _ready():
	# Initialize the Control node and VideoStreamPlayer
	if has_node("/root/Level01/Cutscenes/Crdts/ControlCrdts"):
		control_node = get_node("/root/Level01/Cutscenes/Crdts/ControlCrdts")
		if control_node.has_node("VideoStreamPlayer"):
			video_player = control_node.get_node("VideoStreamPlayer")
			print("Control node and VideoStreamPlayer found!")
		else:
			print("Error: VideoStreamPlayer not found in Control node!")
	else:
		print("Error: Control node not found!")

	# Hide the canvas layer by default
	canvas_layer.visible = false  # Hide the CanvasLayer when the game starts

func _on_body_entered(body):
	# Only trigger the cutscene once
	if body == player and !has_entered:
		start_cutscene()
		has_entered = true  # Set the flag to true to prevent re-triggering

func start_cutscene():
	if control_node and video_player:
		print("Starting cutscene...")

		# Set the CanvasLayer size to 1280x720
		control_node.size = Vector2(1280, 720)  # Set the size of the control node to cover the screen

		# Center the Control node on the screen
		update_control_position()

		# Show the canvas layer for the cutscene
		canvas_layer.visible = true  # Make the CanvasLayer visible for the cutscene

		video_player.play()

		if not video_player.is_connected("finished", Callable(self, "_on_cutscene_finished")):
			video_player.connect("finished", Callable(self, "_on_cutscene_finished"))
	else:
		print("Error: Control node or VideoStreamPlayer not initialized!")

func _on_cutscene_finished():
	print("Cutscene finished.")
	if video_player and video_player.is_connected("finished", Callable(self, "_on_cutscene_finished")):
		video_player.disconnect("finished", Callable(self, "_on_cutscene_finished"))
	if control_node:
		control_node.visible = false

		# Hide the canvas layer after the cutscene is finished
		canvas_layer.visible = false  # Hide the CanvasLayer again after the cutscene

func _process(delta):
	# No longer need to update the position or scale based on the camera or player
	# Canvas is static and doesn't follow the player or camera
	pass

# Function to adjust the position of the control node to cover the screen and be centered
func update_control_position():
	# Calculate the center position of the viewport
	var viewport_center = Vector2(get_viewport().size.x, get_viewport().size.y) / 2

	# Position the control node so that it is centered on the screen
	control_node.position = viewport_center - control_node.size / 2  # Subtract half the size to center it
