class_name StartScreen extends Control

const template_version: String = "0.1"

# These 4 lines are not covered in the initial video. They've been added here just to make it easier for you
# to differentiate versions. I had not intended to provide updates so this feature was skipped in original code.
@onready var version_num: Label = %VersionNum
@onready var recent_list = $"Recent List"

func _ready() -> void:
	version_num.text = "v%s" % template_version

func _on_start_button_up() -> void:
	SceneManager.swap_scenes(SceneRegistry.levels["name"],get_tree().root,self,"wipe_to_right")	

func _on_settings_button_up() -> void:
	Globals.open_settings_menu()

func _on_quit_button_up() -> void:
	# todo add confirmation dialog before quitting
	get_tree().quit()


func _on_load_pressed():
	pass # Replace with function body.
