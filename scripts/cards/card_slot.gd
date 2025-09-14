extends Node2D

var card_in_slots = []
var card_on_top_reference

func _ready() -> void:
	pass

func add_card_to_slot(card):
	card.rotation_degrees = randf_range(-10, 10)
	card_in_slots.append(card)
	print(card.card_value)
	card_on_top_reference.texture =load( "res://CARTAS/"+card_in_slots[card_in_slots.size()-1].card_name+".png")
	card_on_top_reference.rotation_degrees = card_in_slots[card_in_slots.size()-1].rotation_degrees
