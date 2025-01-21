extends CharacterBody2D

@export var speed = 20 
@export var limit = 0.5
@export var endpoint: Marker2D

@onready var animation = $AnimatedSprite2D

var startposition
var endposition

func _ready():
	startposition = position
	endposition = endpoint.global_position
	
func changedirection():
	var tempend = endposition
	endposition = startposition
	startposition = tempend
	
func updatevelocity():
	var movedirection = (endposition - position)
	if movedirection.length() < limit:
		changedirection()
		
	velocity = movedirection.normalized()*speed
	
func updateanimation():
	if velocity.length() == 0:
		if animation.is_playing():
			animation.stop()
	else:
		var direction = "down"
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		
		animation.play("walk" + direction)
	
func _physics_process(delta):
	updatevelocity()
	move_and_slide()
	updateanimation()
