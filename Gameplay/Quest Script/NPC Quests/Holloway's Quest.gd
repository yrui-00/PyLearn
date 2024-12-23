extends Area2D

@export var quest : Quest
@onready var autoload = get_node("/root/Autoloads/state") 
@onready var player = get_node("/root/Level01/Player") as CharacterBody2D

var book1 := load ("res://Gameplay/Inventory Resource/real items/the book.tscn")

func _ready() -> void:
	# Debug quest assignment
	if quest == null:
		print("Quest is not assigned!")
	else:
		print("Quest successfully assigned:", quest)

func _on_body_entered(body: CharacterBody2D) -> void:
	# Check for player
	if body == player and State.duskveil == "true":
		# Ensure quest is valid
		if quest == null:
			print("Quest is not assigned!")
			return
		
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
	new_book.position = $"Holloway's Marker".position
	new_book.quest = quest
