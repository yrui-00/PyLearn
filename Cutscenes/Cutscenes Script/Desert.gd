extends CanvasLayer

@onready var video_player = $Control/VideoStreamPlayer


func _on_button_pressed():
	video_player.stop()  # Stop the video
	video_player.visible = false  # Hide the VideoStreamPlayer
	self.visible = false  # Hide the CanvasLayer
