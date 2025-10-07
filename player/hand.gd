extends Node2D

@onready var hand_counter := $"../HUD/hand_counter"

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
var bullets_bet
var hand_sum
var bust
var life
var can_bet
var player_text_reference
var bullets : Array = []
var bullets_num : int = 3


func _ready() -> void:
	can_bet = 1
	bullets_bet = 0
	life = 3
	win = 0
	double_down=0
	surrender=0
	bust = 0
	player_text_reference = $"../jogador_texto"
	deck_reference = $"../deck"
	deeler_reference = $".."
	stand = 0
	hand_sum = 0
	center_screen_x = get_viewport().size.x/2
	hand_y_position =  (5*(get_viewport().size.y/6)) + 30

func add_card_to_hand(card, speed):
	if card not in player_hand:
		if(card.card_value == 11):
			if hand_sum+11>21:
				card.card_value = 1
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
		if(hand_sum>0) or bullets_bet==6:
			can_bet=0
		
		if (bullets_bet == deeler_reference.min_bet) or bullets_num==0:
			deeler_reference.initial = 1
		
		deeler_reference.bullets_in_game_num +=1
		var offset_x = (deeler_reference.bullets_in_game_num) * 45 + randf_range(-10, 10)
		var offset_y = randf_range(-10, 10) 
		
		bullet.position = Vector2(160, 580) + Vector2(offset_x, offset_y)

		bullets.erase(bullet)
		deeler_reference.bullets_in_game.append(bullet)
		print(deeler_reference.bullets_in_game_num)



func recive_bullet(bullet):
	deeler_reference.bullets_in_game.erase(bullet)
	bullets.insert(0,bullet)
	var offset_x = (bullets_num) * 45 + randf_range(-10, 10)
	var offset_y = randf_range(-10, 10)
	bullet.z_index = 3
	if bullets_num > 6:
		offset_x = (bullets_num - 7) * 45 + randf_range(-10, 10)
		offset_y = 50 + randf_range(-10, 10)
		bullet.z_index = 4
	bullet.position = Vector2(230, 820) + Vector2(offset_x, offset_y)
	bullet.get_node("Area2D").collision_mask = 8
	bullets_num+=1

func update_hand_positions(speed):
	var total = player_hand.size()
	var arc_radius = 350.0 
	var angle_step = deg_to_rad(15)
	var start_angle = -angle_step * (total - 1) / 2  

	for i in range(total):
		var angle = start_angle + i * angle_step
		var x = center_screen_x + sin(angle) * arc_radius
		var y = hand_y_position - cos(angle) * arc_radius * 0.2 
		
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
		hand_sum -= card.card_value
		update_hand_positions(DEFAULT_SPEED)

func reset_hand():
	hand_sum = 0
	bust = 0
	win = 0
	stand = 0
	double_down = 0
	surrender = 0
	player_hand.clear()

func _double_down():
	if not bust and not stand and not double_down and not surrender:
		print("Jogador dobrou a aposta")
		player_text_reference.text = "[wave amp=50 freq=7] Dobrou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		double_down = 1
		deck_reference.draw_card()
		deeler_reference.check_victory()
		deeler_reference.switch_turn()
		
func _surrender():
	if not bust and not stand and not double_down and not surrender:
		print("Jogador se rendeu")
		player_text_reference.text = "[wave amp=50 freq=7] Rendeu [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		surrender = 1
		deeler_reference.check_victory()
		deeler_reference.switch_turn()
