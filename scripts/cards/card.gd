extends Node2D

signal hover_on
signal hover_off

var starter_position

var card_suit
var card_value
var image_path
var power
var activated
var powers_reference
var owner_reference

func _ready() -> void:
	powers_reference = $powers
	activated=0
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hover_on",self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hover_off",self)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		modulate = Color(1, 1, 0.8) # ligeiramente mais clara
		if activated ==0:
			activated=1


func activate_power():
	match power:
		1:
			powers_reference.bust_for_min(owner_reference,self)
