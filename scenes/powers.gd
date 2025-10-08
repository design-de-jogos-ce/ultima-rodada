
extends Node
const NUM_POWERS = 1
const CARD_PATH = "res://scenes/card.tscn"

var player_turn
var deck_reference
var enemy_hand_reference
var player_hand_reference
var database_reference
var player_text_reference
var enemy_text_reference
var main_refrence

var card_database_reference


func _ready() -> void:
	main_refrence = $"."
	player_text_reference = $jogador_texto
	card_database_reference = preload("res://scripts/cards/card_database.gd")
	enemy_text_reference = $inimigo_texto
	player_hand_reference = $"../../hand"
	enemy_hand_reference = $"../../enemy_hand"
	deck_reference = $deck


func bust_for_min(user,card):
	var enemy
	if user == player_hand_reference:
		enemy = enemy_hand_reference
	else: 
		enemy = player_hand_reference
	if card.activated:
		if user.hand_sum>21:
			print("Ativou")
			print(enemy)
			var minor = enemy.player_hand[enemy.player_hand.size()-1]
			for i in range(enemy.player_hand.size()):
				if enemy.player_hand[i].card_value<minor.card_value:
					minor = enemy.player_hand[i]
			user.remove_card_from_hand(card)
			card.activated=-1
			card.queue_free()
			enemy.remove_card_from_hand(minor)
			card.owner_reference = user
			user.add_card_to_hand(minor,0.2)
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
