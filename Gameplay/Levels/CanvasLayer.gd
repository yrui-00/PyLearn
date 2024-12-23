extends CanvasLayer

@onready var editor = $"Code Editor"

func _ready():
	editor.close()

func _input(event):
	if event.is_action_pressed("toggle_editor"):
		if editor.is_open:
			editor.close()
		else:
			editor.open()
