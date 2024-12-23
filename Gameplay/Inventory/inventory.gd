extends Control
signal opened
signal closed
var is_open: bool = false

@onready var inventory: Inventory = preload("res://Gameplay/Inventory Resource/playerinventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


@export var description: NinePatchRect

func _ready():
	inventory.updated.connect(update)
	update()

func update():
	for i in range(slots.size()):
		if i < inventory.items.size():
			slots[i].update(inventory.items[i])
		else:
			slots[i].update(null)  # Clear empty slots

func open():
	visible = true
	is_open = true
	opened.emit()

func close():
	visible = false
	is_open = false
	closed.emit()
	
#description part
func set_description(item: Description):
	description.find_child("Name").text = item.title
	description.find_child("Icon").texture = item.icon
	description.find_child("Description").text = item.description

func clear_description():
	description.find_child("Name").text = ""
	description.find_child("Icon").texture = null
	description.find_child("Description").text = ""
