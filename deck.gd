extends Node2D

const CARD_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2

var deck = ["1_1","1_2","1_3","1_4","1_5","1_6","1_7",
			"1_8","1_9","1_10","1_11","1_12","1_13"]
var card_databese_reference
var hand_reference
var enemy_hand
var deeler_reference
var hand_y_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_reference=$"../hand"
	enemy_hand = $"../enemy_hand"
	deeler_reference= $".."
	deck.shuffle()
	hand_y_position = (5*(get_viewport().size.y/6)) + 50
	card_databese_reference = preload("res://card_database.gd")


func draw_card():
	var card_drawn = deck[0]
	
	deck.erase(card_drawn)

	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false

	var card_scene = preload(CARD_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://assets/"+card_drawn+".png")
	new_card.get_node("card-sprite").texture = load(card_image_path) 
	$"../card-manager".add_child(new_card)
	new_card.name = "Card"
	new_card.card_name = card_drawn
	new_card.card_suit = card_databese_reference.CARDS[card_drawn][0]
	new_card.card_value = card_databese_reference.CARDS[card_drawn][1]
	if deeler_reference.player_turn == 0:
		enemy_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	else:
		hand_reference.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	deeler_reference.switch_turn()
		
