extends Control

func _on_video_stream_player_finished():
	SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"wipe_to_right")


func _on_button_pressed():
	SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"wipe_to_right")
