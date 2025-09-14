extends Node2D

const CARD_WIDTH = 70
const DEFAULT_SPEED= 0.1
const MAX_HAND_SIZE = 3

var hand_y_position
var player_hand = []
var center_screen_x
var revel
var bust
var win
var hand_sum
var stand

func _ready() -> void:
	win = 0
	revel = 0
	stand = 0
	bust = 0
	hand_sum = 0
	center_screen_x = get_viewport().size.x/2
	hand_y_position =  ((get_viewport().size.y/2)) + 150
	

func add_card_to_hand(card, speed):
	if card not in player_hand:
		card.scale=Vector2(0.6,0.6)
		player_hand.insert(0,card)
		hand_sum += card.card_value
		
		update_hand_positions(speed)
	else:
		animate_car_to_position(card,card.starter_position,speed)
		
func update_hand_positions(speed):
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_hand_position(i), hand_y_position)
		var card = player_hand[i]
		card.starter_position = new_position
		animate_car_to_position(card, new_position,speed)
	
func calculate_hand_position(i):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x+ i * CARD_WIDTH - total_width/2
	return x_offset 	
	
func animate_car_to_position(card, new_position,speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_SPEED)
