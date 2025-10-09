
extends Node
const NUM_POWERS = 10
const CARD_PATH = "res://scenes/card.tscn"

var player_turn
var deck_reference
var enemy_hand_reference
var player_hand_reference
var database_reference
var player_text_reference
var enemy_text_reference
var main_refrence
var main 
var card_database_reference


func _ready() -> void:

	card_database_reference = preload("res://scripts/cards/card_database.gd")

	


func bust_for_min(user,card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated==1 and enemy.player_hand.size()!=0:
		print("Ativou")
		print(enemy)
		var minor = enemy.player_hand[enemy.player_hand.size()-1]
		for i in range(enemy.player_hand.size()):
			if enemy.player_hand[i].card_value<minor.card_value:
				minor = enemy.player_hand[i]
		enemy.remove_card_from_hand(minor)
		card.owner_reference = user
		user.add_card_to_hand(minor,0.2)

func doble_card(user, card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated==1:
		user.hand_sum+=card.card_value
		card.activated = -1
		user.att_sum()

func destroy_highest_card(user, card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated==1 and enemy.player_hand.size()!=0:
		var plus = enemy.player_hand[enemy.player_hand.size()-1]
		for i in range(enemy.player_hand.size()):
			if enemy.player_hand[i].card_value>plus.card_value:
				plus = enemy.player_hand[i]
		card.activated=-1
		enemy.remove_card_from_hand(plus)
		plus.queue_free()
		user.att_sum()
func add_one(user, card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated==1:
		card.activated=-1
		user.hand_sum+=1
		user.att_sum()
		print(user.hand_sum)
		

func sub_10(user, card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated == 1:
		card.activated=-1
		user.hand_sum -= 10
		user.att_sum()
		print(user.hand_sum)

func add_one_enemy(user, card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated == 1:
		enemy.hand_sum+=1
		user.att_sum()
		
func sub_one_enemy(user, card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated == 1:
		enemy.hand_sum-=1
		user.att_sum()
		
func rob_card(user,card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated==1 and enemy.player_hand.size()!=0:
		print("Ativou")
		print(enemy)
		var rob = enemy.player_hand[enemy.player_hand.size()-1]
	
		enemy.remove_card_from_hand(rob)
		card.owner_reference = user
		user.add_card_to_hand(rob,0.2)
		user.att_sum()
		
		
		
func now_31(user,card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated==1:
		get_node("/root/Main").table_limit = 31
		user.att_sum()
		
	
	
func porb_21(user,card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated==1:
		if (randi_range(1,10) <= 3):
			user.hand_sum = 20
			user.att_sum()
			
		
		
		
		
