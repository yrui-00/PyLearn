extends Control

@onready var confirmation_dialog = $ConfirmationDialog

func _ready():
	hide()
	$AnimationPlayer.play("RESET")
	
	# Center the confirmation dialog
	confirmation_dialog.position = Vector2(
		size.x / 2 - confirmation_dialog.size.x / 2,
		size.y / 2 - confirmation_dialog.size.y / 2
	)

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func paused():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func esc():
	if Input.is_action_just_pressed("esc") and not get_tree().paused:
		show()
		paused()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		hide()
		resume()

func _on_resume_pressed():
	hide()
	resume()

func _on_restart_pressed():
	hide()
	# Make sure to unpause before scene transition
	get_tree().paused = false
	SceneManager.swap_scenes(SceneRegistry.levels["game_start"], get_tree().root, self, "fade_to_black")

func _on_quit_pressed():
	# Show confirmation dialog instead of quitting directly
	confirmation_dialog.show()
	# Optional: You can set custom text for the dialog
	confirmation_dialog.dialog_text = "Are you sure you want to quit?"

func _on_confirmation_dialog_confirmed():
	# This will be called when user confirms in the dialog
	get_tree().quit()

func _on_confirmation_dialog_canceled():
	confirmation_dialog.hide()

func _process(delta):
	esc()
