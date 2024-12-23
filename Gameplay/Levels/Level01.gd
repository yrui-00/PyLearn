extends Node2D

@onready var audio_player = $AudioStreamPlayer

func _ready():
	# Enable looping and start playing
	audio_player.stream.loop = true
	audio_player.play()


func _on_code_editor_closed():
	get_tree().paused = false

func _on_code_editor_opened():
	get_tree().paused = true


func _on_inventory_opened():
	get_tree().paused = true

func _on_inventory_closed():
	get_tree().paused = false
