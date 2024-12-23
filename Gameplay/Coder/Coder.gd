extends Node
signal editor_opened
signal editor_closed

var is_open: bool = false

@onready var code_edit = $CodeEdit
@onready var run_button = $Button
@onready var output_label = $Panel2/RichTextLabel
var python_thread: Thread
var _mutex: Mutex
var _output: String = ""
var editor_focused: bool = false

func _ready():
	run_button.pressed.connect(_on_run_button_pressed)
	_mutex = Mutex.new()
	python_thread = Thread.new()
	setup_syntax_highlighting()
	setup_theme()
	setup_minimap()
	setup_indent_guides()
	self.visible = false

func open():
	is_open = true
	self.visible = true
	State.set_editor_state(true)

func close():
	is_open = false
	self.visible = false
	State.set_editor_state(false)

func setup_indent_guides():
	# Enable indent guides
	code_edit.draw_tabs = true
	code_edit.indent_size = 4
	code_edit.draw_spaces = false
	
	# Configure indent guide appearance
	code_edit.add_theme_color_override("indent_guide_color", Color("404040"))  # Dark gray color for indent guides
	code_edit.add_theme_constant_override("indent_guide_width", 1)  # Width of the guide line

func setup_minimap():
	# Enable and configure minimap
	code_edit.minimap_draw = true
	code_edit.minimap_width = 60
	
	# Style the minimap
	code_edit.add_theme_color_override("minimap_background", Color("1E1E1E"))
	code_edit.add_theme_color_override("minimap_selection_color", Color(0.247, 0.431, 0.705, 0.5))

func setup_theme():
	# Top button styling
	run_button.text = "RUN"
	run_button.custom_minimum_size = Vector2(70, 28)
	run_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	run_button.add_theme_font_size_override("font_size", 12)
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color("2F3239")
	button_style.border_color = Color("404040")
	button_style.border_width_left = 1
	button_style.border_width_right = 1
	button_style.border_width_top = 1
	button_style.border_width_bottom = 1
	button_style.corner_radius_top_left = 3
	button_style.corner_radius_top_right = 3
	button_style.corner_radius_bottom_left = 3
	button_style.corner_radius_bottom_right = 3
	run_button.add_theme_stylebox_override("normal", button_style)
	run_button.add_theme_color_override("font_color", Color("CCCCCC"))
	
	# Panel Node styling
	var panel = $Panel
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color("1E1E1E")
	panel.add_theme_stylebox_override("panel", panel_style)
	
	# Output panel styling
	var output_panel = $Panel2
	var output_style = StyleBoxFlat.new()
	output_style.bg_color = Color("1E1E1E")
	output_panel.add_theme_stylebox_override("panel", output_style)
	
	# Separator styling
	for child in get_children():
		if child is HSeparator:
			child.add_theme_constant_override("separation", 1)
			child.add_theme_color_override("color", Color("404040"))
	
	# Output text styling - Updated for better readability
	output_label.add_theme_color_override("default_color", Color("CCCCCC"))
	output_label.add_theme_font_size_override("normal_font_size", 16)
	output_label.add_theme_font_size_override("bold_font_size", 16)
	output_label.add_theme_font_size_override("italics_font_size", 16)
	output_label.add_theme_font_size_override("mono_font_size", 16)
	output_label.add_theme_color_override("font_outline_color", Color.BLACK)
	output_label.add_theme_constant_override("outline_size", 1)

func setup_syntax_highlighting():
	# Basic editor colors - VS Code Dark+ colors
	code_edit.add_theme_color_override("background_color", Color("1E1E1E"))
	code_edit.add_theme_color_override("font_color", Color("D4D4D4"))
	code_edit.add_theme_color_override("current_line_color", Color("282828"))
	
	# Create syntax highlighter
	var highlighter = CodeHighlighter.new()
	code_edit.syntax_highlighter = highlighter
	
	# Set basic colors
	highlighter.number_color = Color("B5CEA8")  # Light green for numbers
	highlighter.symbol_color = Color("D4D4D4")  # White for symbols
	highlighter.function_color = Color("DCDCAA")  # Yellow for functions
	highlighter.member_variable_color = Color("9CDCFE")  # Light blue for variables
	
	# Keywords (control flow)
	var keywords = ["def", "if", "else", "elif", "for", "while", "class", "return", 
				   "import", "from", "True", "False", "None", "and", "or", "not", "is", "in", "range"]
	for keyword in keywords:
		highlighter.add_keyword_color(keyword, Color("C586C0"))  # Purple for keywords
	
	# Built-in types
	var types = ["int", "str", "float", "bool", "list", "dict", "set", "tuple"]
	for type in types:
		highlighter.add_keyword_color(type, Color("4EC9B0"))  # Teal for types
	
	# Built-in functions
	var functions = ["print", "len", "range", "sum", "min", "max", "append"]
	for func_name in functions:
		highlighter.add_keyword_color(func_name, Color("DCDCAA"))  # Yellow for functions
	
	# Strings and comments
	highlighter.add_color_region("\"", "\"", Color("CE9178"))  # Orange for strings
	highlighter.add_color_region("'", "'", Color("CE9178"))    # Orange for strings
	highlighter.add_color_region("#", "", Color("6A9955"), true)  # Green for comments
	
	# Editor settings
	code_edit.gutters_draw_line_numbers = true
	code_edit.add_theme_color_override("line_number_color", Color("858585"))
	code_edit.add_theme_color_override("caret_color", Color("A6B39B"))
	code_edit.add_theme_color_override("selection_color", Color(0.247, 0.431, 0.705, 0.5))
	
	code_edit.auto_brace_completion_enabled = true
	code_edit.indent_automatic = true
	code_edit.indent_size = 4
	code_edit.draw_tabs = true
	code_edit.draw_spaces = false

func _on_run_button_pressed():
	if python_thread.is_started():
		output_label.text = "Previous code is still running..."
		return
	
	var code = code_edit.text
	output_label.text = "Running..."
	python_thread.start(_execute_python_code.bind(code))

func _execute_python_code(code: String):
	var output = []
	var exit_code = 0
	
	# Get the actual user directory path
	var dir = OS.get_user_data_dir()
	var temp_file_path = dir.path_join("temp_script.py")
	
	# Create a temporary Python file
	var temp_file = FileAccess.open(temp_file_path, FileAccess.WRITE)
	if temp_file:
		temp_file.store_string(code)
		temp_file.close()
	
	# Execute Python code using OS.execute
	var python_path = "python" # or "python3" depending on your system
	var args = [temp_file_path]
	
	var output_array = []
	exit_code = OS.execute(python_path, args, output_array, true)
	
	# Update the output in the main thread
	call_deferred("_update_output", output_array, exit_code)
	
	# Clean up the temporary file
	DirAccess.remove_absolute(temp_file_path)
	
	call_deferred("_thread_done")

func _update_output(output_array: Array, exit_code: int):
	var final_output = ""
	
	if exit_code != 0:
		final_output = "Error executing code (exit code: %d)" % exit_code
	
	for line in output_array:
		final_output += line + "\n"
	
	if final_output.is_empty():
		final_output = "Code executed successfully with no output."
	
	output_label.text = final_output

func _thread_done():
	python_thread.wait_to_finish()

func _exit_tree():
	if python_thread.is_started():
		python_thread.wait_to_finish()


