extends Area2D 

@onready var player = get_node("/root/Level01/Player") as CharacterBody2D

@export var quest : Quest 
@export var itemresource: Items


func collect(inventory: Inventory):
	inventory.insert(itemresource)

func _on_body_entered(body: CharacterBody2D) -> void:
	# Check for player
	if body == player:
		quest.reached_goal()
		queue_free()
