extends Node2D

signal hover_on
signal hover_off

var starter_position
var card_suit
var card_value
var card_name

func _ready() -> void:
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hover_on",self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hover_off",self)
