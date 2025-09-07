extends Node

var player_turn
var deck_reference
var enemy_hand_reference
var player_hand_reference
var database_reference
var player_text_reference
var enemy_text_reference

@onready var drag := $AnimatedSprite2D

func _ready() -> void:
	player_text_reference = $jogador_texto
	enemy_text_reference = $inimigo_texto
	player_hand_reference = $hand
	enemy_hand_reference = $enemy_hand
	deck_reference = $deck
	database_reference = preload("res://card_database.gd")
	player_turn = 1

func switch_turn():
	
	check_victory()
	
	if (player_turn or player_hand_reference.hand_sum > 21 or player_hand_reference.player_pass):
		player_turn = 0
		enemy_turn()
	else:
		player_turn	= 1
	print(player_turn)
	print("trocou")
	
func check_victory():
	if player_hand_reference.hand_sum > 21 and (not player_hand_reference.player_pass):
		player_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		player_hand_reference.player_pass = 1
		
	if enemy_hand_reference.hand_sum > 21 and (not enemy_hand_reference.enemy_pass):
		enemy_text_reference.text = "[wave amp=50 freq=7]Estourou[/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		enemy_hand_reference.enemy_pass = 1
		
	if player_hand_reference.player_pass and enemy_hand_reference.enemy_pass:
		if (((player_hand_reference.hand_sum > enemy_hand_reference.hand_sum) ) or ((player_hand_reference.hand_sum < enemy_hand_reference.hand_sum) and enemy_hand_reference.hand_sum > 21)) and player_hand_reference.hand_sum <= 21:
			player_text_reference.text = "[wave amp=50 freq=7]Ganhou[/wave]"
			await get_tree().create_timer(1.5).timeout

			
		elif (((player_hand_reference.hand_sum < enemy_hand_reference.hand_sum) ) or ((player_hand_reference.hand_sum > enemy_hand_reference.hand_sum) and player_hand_reference.hand_sum > 21)) and enemy_hand_reference.hand_sum <= 21:
			enemy_text_reference.text = "[wave amp=50 freq=7]Ganhou[/wave]"
			await get_tree().create_timer(1.5).timeout

			
		else:
			player_text_reference.text = "[wave amp=50 freq=7]Empatou[/wave]"
			enemy_text_reference.text = "[wave amp=50 freq=7]Empatou[/wave]"
			await get_tree().create_timer(1.5).timeout
			reset()
			
func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	if !enemy_hand_reference.enemy_pass:
		if enemy_hand_reference.hand_sum > player_hand_reference.hand_sum:
			if player_hand_reference.player_pass:
				
				enemy_hand_reference.enemy_pass = 1
				
				enemy_text_reference.text = "[wave amp=50 freq=7]Inimigo passou[/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				
				print("Inimigo passou")
				switch_turn()
			else:
				var count= 0
				for i in range(deck_reference.deck.size()):
					if database_reference.CARDS[deck_reference.deck[i]][1] + player_hand_reference.hand_sum <= 21:
						count+=1
				if count < deck_reference.deck.size()/3 and not enemy_hand_reference.enemy_pass:
					enemy_hand_reference.enemy_pass = 1
					enemy_text_reference.text = "[wave amp=50 freq=7]Inimigo passou[/wave]"
					await get_tree().create_timer(1.5).timeout
					enemy_text_reference.text = ""
					print("Inimigo passou")
					switch_turn()
				else:
					count= 0
					for i in range(deck_reference.deck.size()):
						if database_reference.CARDS[deck_reference.deck[i]][1] + enemy_hand_reference.hand_sum <= 21:
							count+=1
					if count < deck_reference.deck.size()/3 and not enemy_hand_reference.enemy_pass:
						enemy_hand_reference.enemy_pass = 1
						enemy_text_reference.text = "[wave amp=50 freq=7]Inimigo passou[/wave]"
						await get_tree().create_timer(1.5).timeout
						enemy_text_reference.text = ""
						print("Inimigo passou")
						switch_turn()
					else:
						
						drag.play('pede_carta')
						await get_tree().create_timer(0.8).timeout
						deck_reference.draw_card()
						
						drag.play("idle")
		else:
			var count= 0
			for i in range(deck_reference.deck.size()):
				if database_reference.CARDS[deck_reference.deck[i]][1] + enemy_hand_reference.hand_sum <= 21:
					count+=1
			if count < deck_reference.deck.size()/3 and not enemy_hand_reference.enemy_pass:
				enemy_hand_reference.enemy_pass = 1
				enemy_text_reference.text = "[wave amp=50 freq=7]Inimigo passou[/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				print("Inimigo passou")
				switch_turn()
			else:
				

				
				drag.play('pede_carta')
				
				await get_tree().create_timer(0.8).timeout
				deck_reference.draw_card()
				drag.play("idle")
	else:
		await get_tree().create_timer(1.5).timeout
		switch_turn()
	
func reset():
	# Limpa mão do jogador
	while player_hand_reference.player_hand.size() > 0:
		var card = player_hand_reference.player_hand[0]
		player_hand_reference.remove_card_from_hand(card)
		card.queue_free()  # <- garante que o nó da carta some da tela
	
	# Limpa mão do inimigo
	while enemy_hand_reference.player_hand.size() > 0:
		var card = enemy_hand_reference.player_hand[0]
		enemy_hand_reference.remove_card_from_hand(card)
		card.queue_free()
	player_hand_reference.hand_sum = 0
	enemy_hand_reference.hand_sum = 0
	player_hand_reference.player_pass = 0
	enemy_hand_reference.enemy_pass = 0
	
	deck_reference.deck.clear()
	deck_reference.deck = ["1_1","1_2","1_3","1_4","1_5","1_6","1_7","1_8","1_9","1_10","1_11","1_12","1_13"]
	await get_tree().create_timer(1.5).timeout
	player_text_reference.text = ""
	enemy_text_reference.text = ""
