extends Control

@onready var text_edit = $TextEdit
@onready var submit = $Submit

func _ready():
	# Remove any existing connections first to avoid the duplicate connection error
	if submit.pressed.is_connected(_on_submit_pressed):
		submit.pressed.disconnect(_on_submit_pressed)
	submit.pressed.connect(_on_submit_pressed)

func _on_submit_pressed():
	var entered_name = text_edit.text.strip_edges()
	if entered_name != "":
		# Store the player name in GameData before switching scenes
		State.player_name = entered_name
	# Then switch to the next scene
	SceneManager.swap_scenes(SceneRegistry.levels["intro"], get_tree().root, self, "wipe_to_right")


func _on_button_pressed():
	SceneManager.swap_scenes(SceneRegistry.levels["main"], get_tree().root, self, "wipe_to_right")
