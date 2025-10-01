extends Node

var player_hand_reference
var enemy_hand_reference
var deck_reference
var card_database_reference
var player_turn
var enemy_text_reference

@onready var drag := $AnimatedSprite2D

func enemy_turn():
	if(not enemy_hand_reference.stand or not enemy_hand_reference.bust):
		if(player_hand_reference.bust):
			enemy_hand_reference.stand= 1
			enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			get_parent().switch_turn
			
		elif(player_hand_reference.stand):
			if(player_hand_reference.hand_sum<enemy_hand_reference.hand_sum):
				enemy_hand_reference.stand=1
				enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				get_parent().switch_turn
				
			elif(player_hand_reference.hand_sum >= enemy_hand_reference.hand_sum and not( enemy_hand_reference.hand_sum ==21)):
				var count=0
				for i in range(deck_reference.deck.size()):
					if (enemy_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1])<=21:
						count+=1
				if count> 2*(deck_reference.deck.size()/3):
						drag.play("pede_carta")
						await get_tree().create_timer(1.5).timeout
						drag.play("idle")
						deck_reference.draw_card()
				else:
					enemy_hand_reference.stand=1
					enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
					await get_tree().create_timer(1.5).timeout
					enemy_text_reference.text = ""
					get_parent().switch_turn
		else:
			var count=0
			for i in range(deck_reference.deck.size()):
				if (player_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1])<=21:
					count+=1
			if count< 2*(deck_reference.deck.size()/3):
				enemy_hand_reference.stand=1
				enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				get_parent().switch_turn
			else:
				count=0
				for i in range(deck_reference.deck.size()):
					if (enemy_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1])<=21:
						count+=1
				if count> 2*(deck_reference.deck.size()/3):
						drag.play("pede_carta")
						await get_tree().create_timer(1.5).timeout
						drag.play("idle")
						deck_reference.draw_card()
				else: 
					enemy_hand_reference.stand=1
					enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
					await get_tree().create_timer(1.5).timeout
					enemy_text_reference.text = ""
					get_parent().switch_turn
