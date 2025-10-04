extends Node2D

@onready var hand_counter := $"enemy_counter"

const CARD_WIDTH = 70
const DEFAULT_SPEED= 0.1
const MAX_HAND_SIZE = 3

var hand_y_position
var player_hand = []
var center_screen_x
var revel
var bust
var win
var life
var bullets_bet
var hand_sum
var deeler_reference
var stand
var bullets : Array = []
var bullets_num : int = 3
var can_bet

func _ready() -> void:
	bullets_bet=0
	can_bet = 1
	life = 3
	deeler_reference =  $".."
	win = 0
	revel = 0
	stand = 0
	bust = 0
	hand_sum = 0
	center_screen_x = get_viewport().size.x/2
	hand_y_position =  ((get_viewport().size.y/3))+30 
	

func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0,card)
		hand_sum += card.card_value
		update_hand_positions(speed)
	else:
		animate_car_to_position(card,card.starter_position,speed)
	hand_counter.text = str(hand_sum)
	
	
func bet_bullet():
	if bullets.size() == 0:
		return
	var bullet = bullets[0]
	if bullet in bullets:
		bullets_bet+=1
		bullets_num-=1
		deeler_reference.bullets_in_game_num +=1
		var offset_x = (deeler_reference.bullets_in_game_num) * 45 + randf_range(-10, 10)
		var offset_y = randf_range(-10, 10) 
		
		bullet.position = Vector2(160, 580) + Vector2(offset_x, offset_y)

		bullets.erase(bullet)
		deeler_reference.bullets_in_game.append(bullet)
		can_bet=0
		print(deeler_reference.bullets_in_game_num)

func recive_bullet(bullet):
	deeler_reference.bullets_in_game.erase(bullet)
	bullets.insert(0,bullet)
	var offset_x = (bullets_num) * 45 + randf_range(-10, 10)
	var offset_y = randf_range(-10, 10)
	if bullets_num > 6:
		offset_x = (bullets_num - 7) * 45 + randf_range(-10, 10)
		offset_y = 50 + randf_range(-10, 10)
		bullet.z_index = 4
	bullet.position = Vector2(230, 380) + Vector2(offset_x, offset_y)
	bullet.get_node("Area2D").collision_mask = 10
	bullets_num+=1

func update_hand_positions(speed):
	var total = player_hand.size()
	var arc_radius = 350.0 # raio do arco (quanto maior, mais suave a curva)
	var angle_step = deg_to_rad(15) # ângulo entre cada carta
	var start_angle = -angle_step * (total - 1) / 2  # centraliza o arco

	for i in range(total):
		var angle = start_angle + i * angle_step
		# posição em arco: desloca no X e no Y
		var x = center_screen_x + sin(angle) * arc_radius
		var y = hand_y_position + cos(angle) * arc_radius * 0.2 # 0.2 = achatamento vertical
		
		var new_position = Vector2(x, y)
		var card = player_hand[i]
		card.starter_position = new_position
		animate_car_to_position(card, new_position, speed)
	
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

func reset_hand():
	hand_sum = 0
	bust = 0
	win = 0
	stand = 0
	revel = 0
	can_bet = 1
	player_hand.clear()
