class_name Player extends CharacterBody2D

@export var input_enabled: bool = true
@export var inventory: Inventory
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var finder: Area2D = $Direction/Finder
@onready var score_label = %Score
@onready var name_label = $Label
var score_counter = 0
var move_dir: Vector2
const SPEED = 125.0
var last_direction: String = "down"

func _ready():
	if State.player_name !="":
		name_label.text = State.player_name
	State.editor_state_changed.connect(_on_editor_state_changed)

func _on_editor_state_changed(editor_open: bool):
	input_enabled = !editor_open
	if editor_open:
		velocity = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled:
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
		return

func _physics_process(_delta: float) -> void:
	if not input_enabled:
		velocity = Vector2.ZERO  # Stop movement immediately when disabled
		return 
	
	move_dir = Vector2(Input.get_axis("ui_left", "ui_right"), 
					  Input.get_axis("ui_up", "ui_down"))
	orient(move_dir)
	
	# Animation player
	if velocity.length() == 0:
		animation.stop()
	else:
		var direction = "down"
		if velocity.x < 0: direction = "right"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		
		animation.play("walk_" + direction)
		last_direction = direction
	
	if move_dir != Vector2.ZERO:
		var diagonal_dampening: float = 1
		if velocity.x != 0 and velocity.y != 0:
			diagonal_dampening = .7
		velocity.x = move_dir.x * SPEED * diagonal_dampening
		velocity.y = move_dir.y * SPEED * diagonal_dampening
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
	
	if State.is_editor_open or not input_enabled:
		velocity = Vector2.ZERO
		return

func orient(dir: Vector2) -> void:
	if dir.x:
		sprite.flip_h = dir.x < 0

func disable():
	input_enabled = false
	
func enable():
	input_enabled = true
	visible = true

# Signal handlers for the editor
func _on_code_editor_opened():
	input_enabled = false
	velocity = Vector2.ZERO

func _on_code_editor_closed():
	input_enabled = true

func _on_collector_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
		set_score(score_counter + 25)
		print(score_counter)

func set_score(new_score: int) -> void:
	score_counter = new_score
	score_label.text = "Score: " + str(score_counter)
