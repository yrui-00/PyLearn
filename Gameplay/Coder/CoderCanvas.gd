extends CanvasLayer

@onready var editor = $Coder

func _unhandled_input(event):
	# Handle the editor toggle first
	if event.is_action_pressed("coder"):
		if editor.is_open:
			editor.close()
		else:
			editor.open()
		get_viewport().set_input_as_handled()
		return

	# If editor is open, consume ALL game input events
	if editor.is_open:
		if event is InputEventKey or event is InputEventMouseButton:
			# Let typing events through to the editor
			if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
				return
			# Mark other events as handled to prevent them from reaching other nodes
			get_viewport().set_input_as_handled()
