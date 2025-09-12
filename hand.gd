extends Node2D

const CARD_WIDTH = 150
const DEFAULT_SPEED= 0.1

var hand_y_position
var player_hand = []
var center_screen_x
var surrender
var stand
var deck_reference
var deeler_reference
var double_down
var win
var hand_sum
var bust


func _ready() -> void:
	win = 0
	double_down=0
	surrender=0
	bust = 0
	deck_reference = $"../deck"
	deeler_reference = $".."
	stand = 0
	hand_sum = 0
	center_screen_x = get_viewport().size.x/2
	hand_y_position =  (5*(get_viewport().size.y/6)) + 115

func add_card_to_hand(card, speed):
	if card not in player_hand:
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

func _double_down():
	print("Jogador dobrou a aposta")
	double_down = 1
	deck_reference.draw_card()
	deeler_reference.check_victory()
	deeler_reference.switch_turn()
	
func _surrender():
	print("Jogador se rendeu")
	surrender = 1
	deeler_reference.check_victory()
	deeler_reference.switch_turn()
