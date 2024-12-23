extends Node

var gold = 50
var xp = 100

func _process(delta: float ) -> void:
	$CanvasLayer/Gold.text = str(gold)
	$CanvasLayer/XP.text = str(xp)

