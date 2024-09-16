extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var background = $ColorRect

var isEmpty = true
var selfIndex
var value

signal cellClicked(selfIndex)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mousey_clicky"):
		emit_signal("cellClicked", selfIndex)
