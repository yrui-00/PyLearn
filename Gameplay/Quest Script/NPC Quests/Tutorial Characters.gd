extends Area2D

@export var quest : Quest

@onready var player = get_node("/root/Level01/TileMap/Player") as CharacterBody2D

var book1 := load ("res://Gameplay/Inventory Resource/real items/tutorial.tscn")

func _on_body_entered(body: CharacterBody2D) -> void:
	# Check for player
	if body == player:
		# If quest is available
		if quest.quest_status == quest.QuestStatus.available:
			# Start the quest
			quest.start_quest()
			# Spawning of the book (using call_deferred)
			call_deferred("spawn_book")

		# If player reached goal
		if quest.quest_status == quest.QuestStatus.goal:
			# Finish the quest
			quest.finish_quest()

func spawn_book() -> void:
	# Instantiate and add the book after physics processing
	var new_book = book1.instantiate()
	add_child(new_book)
	# Set the position and assign quest
	new_book.position = $Book1Spawn.position
	new_book.quest = quest
