extends Control


func _on_button_pressed():
	get_tree().quit()


func _on_video_stream_player_finished():
	get_tree().quit()
