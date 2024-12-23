extends Control

@onready var editor = $Editor

@onready var file_tab = $TabPanel/Tabs/File
@onready var edit_tab = $TabPanel/Tabs/Edit
@onready var format_tab = $TabPanel/Tabs/Format
@onready var view_tab = $TabPanel/Tabs/View
@onready var help_tab = $TabPanel/Tabs/Help

#line 315 minodify para sa notification popup kung magsasave ba or hindi ng file
#tinanggal ko kasi papalitan ko ng pause menu

var is_open: bool = false

signal opened
signal closed

var current_file_path = ""
var last_editor_text = ""

var action = ""
var can_action = false
var action_value = 0 

var last_font = ""
var last_font_name = ""
var last_font_size = 0
var last_font_color: Color

var data: Dictionary
var default_data = {
	"FilePath": "C://Users/User/Documents",
	"StatusBar": true,
	"LineNumber": true,
	"Minimap": true,
	"WordWrap": false,
	"Font": "",
	"FontName": "Default",
	"FontSize": 16,
	"FontColor": [1, 1, 1]
}

var last_img 

var data_path = "user://PyGramData.dat"

var function_names = []
var variable_names = []

func _ready():
	load_data()
	new_file()
	
	editor.grab_focus()
	editor.clear_undo_history()
	
	for f in ["New", "Open", "Save", "Save As...", "", "Take Screenshot", "Exit"]:
		if f:
			file_tab.get_popup().add_item(f)
		else:
			file_tab.get_popup().add_separator()
	for e in ["Undo", "Redo", "", "Cut", "Copy", "Paste", "Delete", "", "Select All", "Clear", "", "Search with Google", "Time/Date"]:
		if e:
			edit_tab.get_popup().add_item(e)
		else:
			edit_tab.get_popup().add_separator()
	for fm in ["Word Wrap", "Font"]:
		if fm == "Word Wrap":
			format_tab.get_popup().add_check_item(fm)
		else:
			format_tab.get_popup().add_item(fm)
	for v in ["Line Number", "Minimap", "Status Bar", "Fullscreen"]:
		view_tab.get_popup().add_check_item(v)
		
	view_tab.get_popup().set_item_checked(0, true)
	view_tab.get_popup().set_item_checked(1, true)
	view_tab.get_popup().set_item_checked(2, true)
	
	
	for h in ["About"]:
		help_tab.get_popup().add_item(h)
		
	for control_keyword in ["if", "else", "elif", "switch", "case", "default", "break", "continue", "return", "for", "while", "do", "foreach", "pass"]:
		editor.syntax_highlighter.add_keyword_color(control_keyword, Color("#ff8ccc"))
	for keyword in ["var", "int", "bool", "float", "double", "char", "string", "true", "false", "void", "True", "False", "function", "def", "func", "class", "private", "print", "method", "try", "catch", "finally", "throw", "and", "or", "not", "null", "undefined", "in", "final", "static", "let", "const", "export", "import", "internal", "echo", "extends", "super", "this"]:
		editor.syntax_highlighter.add_keyword_color(keyword, Color("#ff7085"))
	
	editor.syntax_highlighter.add_color_region('"', '"', Color("#ffeda1"))
	editor.syntax_highlighter.add_color_region("'", "'", Color("#ffeda1"))
	#editor.syntax_highlighter.add_color_region("<", ">", Color.GOLDENROD)
	editor.syntax_highlighter.add_color_region("//", "", Color("#cdcfd280"))
	editor.syntax_highlighter.add_color_region("/*", "*/", Color("#cdcfd280"), false)
	editor.syntax_highlighter.add_color_region("#", "", Color("#cdcfd280"))
	
	file_tab.get_popup().connect("id_pressed", _on_file_option_selected)
	edit_tab.get_popup().connect("id_pressed", _on_edit_option_selected)
	format_tab.get_popup().connect("id_pressed", _on_format_option_selected)
	view_tab.get_popup().connect("id_pressed", _on_view_option_selected)
	help_tab.get_popup().connect("id_pressed", _on_help_option_selected)
	
	file_tab.get_popup().set_item_shortcut(0, get_shortcut("new_file"), true)
	file_tab.get_popup().set_item_shortcut(1, get_shortcut("open_file"), true)
	file_tab.get_popup().set_item_shortcut(2, get_shortcut("save_file"), true)
	file_tab.get_popup().set_item_shortcut(3, get_shortcut("save_as_file"), true)
	file_tab.get_popup().set_item_shortcut(5, get_shortcut("take_screenshot"), true)
	file_tab.get_popup().set_item_shortcut(6, get_shortcut("exit"), true)
	
	edit_tab.get_popup().set_item_shortcut(0, get_shortcut("undo"), true)
	edit_tab.get_popup().set_item_shortcut(1, get_shortcut("redo"), true)
	edit_tab.get_popup().set_item_shortcut(3, get_shortcut("cut"), true)
	edit_tab.get_popup().set_item_shortcut(4, get_shortcut("copy"), true)
	edit_tab.get_popup().set_item_shortcut(5, get_shortcut("paste"), true)
	edit_tab.get_popup().set_item_shortcut(6, get_shortcut("delete"), true)
	edit_tab.get_popup().set_item_shortcut(8, get_shortcut("select_all"), true)
	edit_tab.get_popup().set_item_shortcut(9, get_shortcut("clear"), true)
	edit_tab.get_popup().set_item_shortcut(11, get_shortcut("search"), true)
	edit_tab.get_popup().set_item_shortcut(12, get_shortcut("datetime"), true)
	
	format_tab.get_popup().set_item_shortcut(0, get_shortcut("word_wrap"), true)
	
	view_tab.get_popup().set_item_shortcut(0, get_shortcut("line_number"), true)
	view_tab.get_popup().set_item_shortcut(1, get_shortcut("minimap"), true)
	view_tab.get_popup().set_item_shortcut(2, get_shortcut("status_bar"), true)
	view_tab.get_popup().set_item_shortcut(3, get_shortcut("full_screen"), true)
	
	help_tab.get_popup().set_item_shortcut(0, get_shortcut("about"), true)
	
	last_font = data["Font"]
	last_font_name = data["FontName"]
	last_font_size = data["FontSize"]
	last_font_color = Color(data["FontColor"][0], data["FontColor"][1], data["FontColor"][2])
	
	editor.minimap_draw = data["Minimap"]
	editor.gutters_draw_line_numbers = data["LineNumber"]
	editor.wrap_mode = 1 if data["WordWrap"] else 0
	editor.size.y = 608+3 if !data["StatusBar"] else 568
	$StatusBar.visible = data["StatusBar"]
	
	editor.size.y += 1
	
	$FontSettings/Options/Font/FontPath.text = data["FontName"]
	$FontSettings/Options/FontSize/FontSizeInput.value = data["FontSize"]
	$FontSettings/Options/FontColor/ColorPickerButton.color = last_font_color
	
	load_editor_font()
	reload_editor()
	
	get_tree().set_auto_accept_quit(false)
	
func update_window_title():
	if current_file_path:
		DisplayServer.window_set_title("PyGram - " + current_file_path.get_file())
	else:
		DisplayServer.window_set_title("PyGram")
	
func get_shortcut(key):
	var input_event = InputEventAction.new()
	input_event.set_action(key)
	var shortcut = Shortcut.new()
	shortcut.set_events([input_event])
	return shortcut

func Screenshot():
	await RenderingServer.frame_post_draw
	var img = get_viewport().get_texture().get_image()
	last_img = img 

func _on_file_option_selected(id):
	match id:
		0:
			new_file()
		1: 
			$OpenFile.popup()
		2:
			if FileAccess.file_exists(current_file_path):
				save_file("")
			else:
				$SaveFile.popup()
		3:
			$SaveFile.popup()
		5:
			await Screenshot()
			$SaveScreenshot.popup()
		6:
			if !check_save():
				$SaveChangesWarning.popup()
				action = "exit"
				can_action = true
				return
				
			get_tree().quit()

func _on_edit_option_selected(id):
	match id:
		0:
			editor.undo()
		1: 
			editor.redo()
		3: 
			editor.cut()
		4:
			editor.copy()
		5:
			editor.paste()
		6: 
			editor.delete_selection()
		8:
			editor.select_all()
		9:
			editor.text = ""
		11:
			var text = editor.text
			#var search_query = text.replace(" ", "+")
			var search_engine_url = "https://www.online-python.com/"
			var search_url = search_engine_url 
			#+ search_query
			
			OS.shell_open(search_url)
		12:
			var datetime = Time.get_datetime_dict_from_system(false)
			var time = str(datetime["hour"]) + ":" + str(datetime["minute"])
			var date = str(datetime["day"]) + "/" + str(datetime["month"]) + "/" + str(datetime["year"])
			
			editor.insert_text_at_caret(time + " " + date)

func _on_format_option_selected(id):
	match id:
		0:
			format_tab.get_popup().set_item_checked(id, !format_tab.get_popup().is_item_checked(id))
			editor.wrap_mode = 1 if !format_tab.get_popup().is_item_checked(id) else 0
			save_data("WordWrap", format_tab.get_popup().is_item_checked(id))
		1:
			$FontSettings.popup()

func _on_view_option_selected(id):
	view_tab.get_popup().set_item_checked(id, !view_tab.get_popup().is_item_checked(id))
	var is_item_checked = view_tab.get_popup().is_item_checked(id)
	match id:
		0:
			editor.gutters_draw_line_numbers = is_item_checked
			save_data("LineNumber", is_item_checked)
		1:
			editor.minimap_draw = is_item_checked
			save_data("Minimap", is_item_checked)
		2:
			$StatusBar.visible = is_item_checked
			$StatusBar/HSeparator.visible = is_item_checked
			editor.size.y += 43 if !is_item_checked else -43
			save_data("StatusBar", is_item_checked)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_item_checked else DisplayServer.WINDOW_MODE_WINDOWED)

func save_data(what, value):
	var file = FileAccess.open(data_path, FileAccess.WRITE)
	data[what] = value
	file.store_string(str(data))
	file.close()
	
func load_data():
	var file
	if FileAccess.file_exists(data_path):
		file = FileAccess.open(data_path, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
	else:
		file = FileAccess.open(data_path, FileAccess.WRITE)
		file.store_string(str(default_data))

func _on_help_option_selected(_id):
	$About.popup()
	

func new_file():
	editor.text = ""
	current_file_path = ""
	last_editor_text = ""
	reload_editor()

func reload_editor():
	$OpenFile.current_dir = data["FilePath"]
	$OpenFile.current_file = ""
	$SaveFile.current_dir = data["FilePath"]
	$SaveFile.current_file = ""
	$SaveScreenshot.current_dir = data["FilePath"]
	$SaveScreenshot.current_file = ""
	
	update_window_title()
	
func save_file(path):
	var file
	if path:
		file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(editor.text)
		current_file_path = path
		reload_editor()
	else:
		file = FileAccess.open(current_file_path, FileAccess.WRITE)
		file.store_string(editor.text)
		
	last_editor_text = editor.text
	file.close()

func open_file(path):
	action = "open"
	action_value = path
	if !check_save() and !can_action:
		$SaveChangesWarning.popup()
		can_action = true
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	editor.text = file.get_as_text()
	current_file_path = path
	last_editor_text = editor.text
	reload_editor()
	file.close()
	
#func _notification(what):
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#if check_save():
			#$SaveChangesWarning.popup()
			#action = "exit"
			#can_action = true
			#return
			
			#get_tree().quit()

func _on_open_file_selected(path):
	open_file(path)
	save_data("FilePath", path.replace("/" + path.get_file(), ""))

func _on_save_file_selected(path):
	save_file(path)
	save_data("FilePath", path.replace("/" + path.get_file(), ""))
	
	match action:
		"open":
			can_action = false
			open_file(action_value)
		"exit":
			$SaveChangesWarning.hide()
			get_tree().quit()
			
	action = ""
	action_value = null
	can_action = false

func _on_save_screenshot_file_selected(path):
	var img: Image = last_img
	if path.get_extension() == "png":
		img.save_png(path)
	else:
		img.save_png(path + ".png")
	
	save_data("FilePath", path.replace("/" + path.get_file(), ""))

func _on_open_font_file_selected(path):
	save_data("FilePath", path.replace("/" + path.get_file(), ""))
	if path.get_extension() != "ttf":
		OS.alert("This is not a .ttf file")
		return
		
	last_font = path
	last_font_name = path.get_file().replace("."+path.get_extension(), "")
	$FontSettings/Options/Font/FontPath.text = last_font_name
	var font_v = FontFile.new()
	editor.set("theme_override_fonts/font", font_v)
	
	reload_editor()


func load_editor_font():
	var font = data["Font"]
	
	if data["Font"]:
		var font_v = FontFile.new()
		font_v.load_dynamic_font(font)
		editor.set("theme_override_fonts/font", font_v)
	else:
		editor.set("theme_override_fonts/font", SystemFont.new())
		
	editor.set("theme_override_font_sizes/font_size", data["FontSize"])
	editor.set("theme_override_colors/font_color", Color(data["FontColor"][0], data["FontColor"][1], data["FontColor"][2]))
	
func _on_font_settings_confirmed():
	save_data("FontSize", last_font_size)
	#save_data("Font", last_font)
	save_data("FontName", last_font_name)
	save_data("FontColor", [last_font_color.r, last_font_color.g, last_font_color.b])
	if last_font_name != "Default":
		save_data("Font", last_font)#.replace("/" + last_font.get_file(), ""))
	else:
		last_font = ""

	load_editor_font()

func _on_font_settings_canceled():
	$FontSettings/Options/Font/FontPath.text = data["FontName"]
	$FontSettings/Options/FontSize/FontSizeInput.value = data["FontSize"]
	$FontSettings/Options/FontColor/ColorPickerButton.color = Color(data["FontColor"][0], data["FontColor"][1], data["FontColor"][2])

func _on_font_size_input_value_changed(value):
	last_font_size = value
	editor.set("theme_override_font_sizes/font_size", last_font_size)
	
func _on_color_picker_button_color_changed(color):
	editor.set("theme_override_colors/font_color", color)

func _on_open_font_button_pressed():
	$OpenFont.popup()

func check_save():
	if action == "open" and (editor.text) or (editor.text and !FileAccess.file_exists(current_file_path) or (editor.text != last_editor_text)):
		return false
	if editor.text and !FileAccess.file_exists(current_file_path):
		return false
	elif editor.text != last_editor_text:
		return false
	
	return true


func _on_save_button_pressed():
	if FileAccess.file_exists(current_file_path):
		save_file("")
		$SaveChangesWarning.hide()
		get_tree().quit()
	else:
		$SaveFile.popup()
		action = "exit"


func _on_unsave_button_pressed():
	match action:
		"open":
			can_action = false
			open_file(action_value)
		"exit":
			$SaveChangesWarning.hide()
			get_tree().quit()
			
	action = ""
	action_value = null
	can_action = false
	$SaveChangesWarning.hide()

func _on_cancel_button_pressed():
	$SaveChangesWarning.hide()

func extract_variable_names(line):
	var pattern = "var\\s+([a-zA-Z_][a-zA-Z0-9]*)\\s*=\\s*(\\d+|\"[^\"]*\"|\\{[^\\}]*\\})"
	
	var regex= RegEx.new()
	regex.compile(pattern)
	
	var matches = regex.search_all(line)
	
	for match_var in matches:
		var variable_name = match_var.get_string(1)
		return variable_name

func _on_editor_text_changed():
	for classes in ["if", "else", "elif", "switch", "case", "default", "break", "continue", "return", "for", "while", "do", "foreach", "pass","var", "int", "bool", "float", "double", "char", "string", "true", "false", "void", "True", "False", "function", "def", "func", "class", "private", "print", "method", "try", "catch", "finally", "throw", "and", "or", "not", "null", "undefined", "in", "final", "static", "let", "const", "export", "import", "internal", "echo", "extends", "super", "this"]:
		editor.add_code_completion_option(CodeEdit.KIND_CLASS, classes, classes)
	
	var editor_content = editor.text
	
	var lines = editor_content.split("\n")
	var variable_name
	
	for line in lines:
		if (line.begins_with("func ") or line.begins_with("def ")) and line.find("(") != -1 and line.find(")") != -1:
			var function_code = ""
			if line.begins_with("func "):
				function_code = "func "
			if line.begins_with("def "):
				function_code = "def "
			
			var function_name: String = line.trim_prefix(function_code).trim_suffix(":").strip_edges()
			if !function_names.has(function_name):
				if function_name.begins_with("def "):
					function_name = function_name.replace("def ", "")
				elif function_name.begins_with("func "):
					function_name = function_name.replace("func ", "")
				function_names.append(function_name)
		
		if line.begins_with("var ") and line.find("=") != 1:
			var variable_names = extract_variable_names(line)
			if variable_name and !variable_names.has(variable_name):
				if variable_name.begins_with("var "):
					variable_name = variable_name.replace("var " + "")
					
				variable_names.append(variable_name)
		
		for each_f in function_names:
			editor.add_code_completion_option(CodeEdit.KIND_FUNCTION, each_f, each_f)
		for each_v in variable_names:
			editor.add_code_completion_option(CodeEdit.KIND_VARIABLE, each_v, each_v)
			editor.update_code_completion_options(true)
			
func _physics_process(_delta):
	edit_tab.get_popup().set_item_disabled(0, !editor.has_undo())
	edit_tab.get_popup().set_item_disabled(1, !editor.has_redo())
	edit_tab.get_popup().set_item_disabled(8, !editor.text)
	edit_tab.get_popup().set_item_disabled(9, !editor.text)
	$StatusBar/Label.text = "Line - " + str(editor.get_caret_line()) + ", Column - " + str(editor.get_caret_column())

	if $FontSettings/Options/Font/FontPath.has_focus() and Input.is_action_just_pressed("delete"):
		$FontSettings/Options/Font/FontPath.text = "Default"
		last_font_name = "Default"
		last_font = ""
		editor.set("theme_override_fonts/font", SystemFont.new())

func open():
	visible = true
	is_open = true
	opened.emit()
	
func close():
	visible = false
	is_open = false
	closed.emit()
	
