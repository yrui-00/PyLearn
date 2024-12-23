extends Panel

@onready var background: Sprite2D = $bg
@onready var itemsprite: Sprite2D = $CenterContainer/Panel/item

# Update slot visuals and visibility based on item presence
func update(item: Items):
	if !item:
		background.frame = 0
		itemsprite.visible = false
	else:
		background.frame = 1
		itemsprite.visible = true
		itemsprite.texture = item.texture

# Description part
@export var item: Description:
	set(value):
		item = value

func _on_mouse_entered():
	# Only show the description if the background frame is 1
	if background.frame == 1 and item != null:
		owner.set_description(item)

func _on_mouse_exited():
	pass
	# Only clear the description if the background frame is 1
	#if background.frame == 1 and item != null:
		#owner.clear_description()
