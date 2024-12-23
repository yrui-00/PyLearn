extends Area2D

@onready var player = get_node("/root/Level01/TileMap/Player") as CharacterBody2D

@export var quest : Quest 

func _on_body_entered(body: CharacterBody2D) -> void:
	# Check for player
	if body == player:
		quest.reached_goal()
		queue_free()
