extends CanvasLayer

@onready var video_player = $Control/VideoStreamPlayer

func _on_button_pressed():
	video_player.stop()
	video_player.visible = false
	self.visible = false
