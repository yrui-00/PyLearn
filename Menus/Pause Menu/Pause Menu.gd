extends Control

func _ready():
	hide()
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func paused():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func esc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		show()
		paused()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		hide()
		resume()

func _on_resume_pressed():
	hide()
	resume()


func _on_restart_pressed():
	hide()
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	esc()
