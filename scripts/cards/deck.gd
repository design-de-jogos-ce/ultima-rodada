extends Node2D

const CARD_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2
const PROB_HABILITY = 1# 50%

@onready var card_sound := $'../sfx/card_into_hand'
@onready var card_sound2 := $'../sfx/card_into_hand2'


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
var powers_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	powers_reference = $powers
	hand_reference=$"../hand"
	animation_reference = $"../AnimatedSprite2D"
	enemy_hand = $"../enemy_hand"
	deeler_reference= $".."
	deck.shuffle()
	hand_y_position = (5*(get_viewport().size.y/6)) + 50
	card_databese_reference = preload("res://scripts/cards/card_database.gd")
	back = str("res://assets/verso.png")
	

func draw_card():
	randomize() 
	var card_drawn = deck[0]
	deck.erase(card_drawn)
	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	var card_scene = preload(CARD_PATH)
	var new_card = card_scene.instantiate()
	new_card.image_path = str("res://assets/"+card_drawn+"_color.png")
	new_card.image_name = card_drawn
	$"../card-manager".add_child(new_card)
	#var sound = randi_range(1, 2)
	#if sound == 1:
		#card_sound.play()
	#else:
	card_sound2.play()
		
	#	new_card.image_path = str("res://assets/"+card_drawn+"_black.png")
	
	new_card.get_node("card-sprite").texture = load(new_card.image_path) 
	new_card.name = "Card"
	new_card.card_suit = card_databese_reference.CARDS[card_drawn][0]
	new_card.card_value = card_databese_reference.CARDS[card_drawn][1]
	if card_drawn == "1_11" or card_drawn == "1_12" or card_drawn == "1_13":
		new_card.power = randi_range(1,new_card.powers_reference.NUM_POWERS)

		print("essa carta é especial")
		new_card.powers_reference.player_hand_reference = hand_reference
		new_card.powers_reference.enemy_hand_reference = enemy_hand
		
	if deeler_reference.player_turn == 0:
		new_card.owner_reference = enemy_hand
		enemy_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	else:
		new_card.owner_reference = hand_reference
		new_card.player = 1
		hand_reference.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	deeler_reference.switch_turn()


func reset_deck():
	deck = ["1_1","1_2","1_3","1_4","1_5","1_6","1_7",
			"1_8","1_9","1_10","1_11","1_12","1_13", "1_11","1_12","1_13",
			"2_1","2_2","2_3","2_4","2_5","2_6","2_7",
			"2_8","2_9","2_10","2_11","2_12","2_13", "2_11","2_12","2_13", 
			"3_1","3_2","3_3","3_4","3_5","3_6","3_7",
			"3_8","3_9","3_10","3_11","3_12","3_13", "3_11","3_12","3_13", 
			"4_1","4_2","4_3","4_4","4_5","4_6","4_7",
			"4_8","4_9","4_10","4_11","4_12","4_13","4_11","4_12","4_13"]
	
	deck.shuffle()
	$Area2D/CollisionShape2D.disabled = false
	$Sprite2D.visible = true
