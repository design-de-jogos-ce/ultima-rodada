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
			image_path = str("res://assets/"+image_name+"_black.png")
			get_node("card-sprite").texture = load(image_path) 
			activated = 1

func activate_power():
	match power:
		1:
			powers_reference.bust_for_min(owner_reference, self)

func show_description():
	description_label.visible = true
	description_label.text = get_description_text()
	description_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	var card_size = $'card-sprite'.texture.get_size()

	description_label.global_position = self.global_position + Vector2( -card_size.x / 2,- 125)
	

func hide_description():
	description_label.visible = false

func get_description_text() -> String:
	match power:
		1:
			return "Se estourar roube a menor carta do inimigo"
		2:
			return "🛡️ Protege esta carta de efeitos por 1 turno."
		3:
			return "🎯 Dobra o valor desta carta."
		_:
			return ""
