extends Node2D

const CARD_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2

var deck = ["1_1","1_2","1_3","1_4","1_5","1_6","1_7",
			"1_8","1_9","1_10","1_11","1_12","1_13", 
			"2_1","2_2","2_3","2_4","2_5","2_6","2_7",
			"2_8","2_9","2_10","2_11","2_12","2_13", 
			"3_1","3_2","3_3","3_4","3_5","3_6","3_7",
			"3_8","3_9","3_10","3_11","3_12","3_13", 
			"4_1","4_2","4_3","4_4","4_5","4_6","4_7",
			"4_8","4_9","4_10","4_11","4_12","4_13"
			]
var card_databese_reference
var hand_reference
var enemy_hand
var deeler_reference
var animation_reference
var hand_y_position
var back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_reference=$"../hand"
	animation_reference = $"../AnimatedSprite2D"
	enemy_hand = $"../enemy_hand"
	deeler_reference= $".."
	deck.shuffle()
	hand_y_position = (5*(get_viewport().size.y/6)) + 50
	card_databese_reference = preload("res://scripts/cards/card_database.gd")
	back = str("res://assets/verso.png")


func draw_card():
	var card_drawn = deck[0]
	deck.erase(card_drawn)
	
	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false

	var card_scene = preload(CARD_PATH)
	var new_card = card_scene.instantiate()
	new_card.image_path = str("res://assets/"+card_drawn+".png")
	new_card.get_node("card-sprite").texture = load(new_card.image_path) 
	$"../card-manager".add_child(new_card)
	new_card.name = "Card"
	new_card.card_suit = card_databese_reference.CARDS[card_drawn][0]
	new_card.card_value = card_databese_reference.CARDS[card_drawn][1]
	if deeler_reference.player_turn == 0:
		
		enemy_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
		
		
		
	else:
		hand_reference.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	if deeler_reference.initial:
		deeler_reference.check_victory()


func reset_deck():
	deck = ["1_1","1_2","1_3","1_4","1_5","1_6","1_7",
			"1_8","1_9","1_10","1_11","1_12","1_13", 
			"2_1","2_2","2_3","2_4","2_5","2_6","2_7",
			"2_8","2_9","2_10","2_11","2_12","2_13", 
			"3_1","3_2","3_3","3_4","3_5","3_6","3_7",
			"3_8","3_9","3_10","3_11","3_12","3_13", 
			"4_1","4_2","4_3","4_4","4_5","4_6","4_7",
			"4_8","4_9","4_10","4_11","4_12","4_13"
			]
	deck.shuffle()
	$Area2D/CollisionShape2D.disabled = false
	$Sprite2D.visible = true
