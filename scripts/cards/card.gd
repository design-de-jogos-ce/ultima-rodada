extends Node2D

signal hover_on
signal hover_off

var starter_position
var card_suit
var card_value
var image_path
var image_name
var power
var player
var activated
var powers_reference
var owner_reference
var enemy_reference

@onready var description_label := $description_label

func _ready() -> void:
	powers_reference = $powers
	activated = 0
	player=0
	description_label.visible = false
	power=0
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hover_on", self)
	show_description()

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hover_off", self)
	hide_description()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if activated == 0 and player and power != 0:
			activated = 1
			image_path = str("res://assets/"+image_name+"_black.png")
			activate_power()
			get_node("card-sprite").texture = load(image_path) 
			

func activate_power():
	match power:
		1:
			powers_reference.bust_for_min(owner_reference, self)
		2:
			powers_reference.doble_card(owner_reference, self)
		3:
			powers_reference.destroy_highest_card(owner_reference, self)
		4: 
			powers_reference.add_one(owner_reference, self)
		5:
			powers_reference.sub_10(owner_reference, self)
		6:
			powers_reference.add_one_enemy(owner_reference, self)
		7:
			powers_reference.sub_one_enemy(owner_reference, self)
		8:
			powers_reference.rob_card(owner_reference, self)
		9:
			powers_reference.porb_21(owner_reference, self)
		10:
			powers_reference.now_31(owner_reference, self)

func show_description():
	description_label.visible = true
	description_label.text = get_description_text()
	description_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description_label.position.x = -6*description_label.text.length()
	print(description_label.text.length())
	print(description_label.position.x)
	description_label.position.y = -170

	

func hide_description():
	description_label.visible = false

func get_description_text() -> String:
	match power:
		1:
			return "Roube a menor carta do inimigo"
		2:
			return "Some +10"
		3:
			return "Apague a maior carta do inimigo"
		4:
			return "Some +1"
		5:
			return "Some -10"
		6:
			return "Some +1 ao baralho inimigo"
		7:
			return "Some -1 ao baralho inimigo"
		8:	
			return "Roube a última carta do inimigo"
		9:
			return "30% de chegar em 20"
		10:
			return "Agora é 31"
		_:
			return ""
