extends Node

var player_turn
var deck_reference
var enemy_hand_reference
var player_hand_reference
var database_reference
var player_text_reference
var enemy_text_reference
var table_limit
var card_database_reference
var initial
var player_life
var enemy_life
var bullets

@onready var drag := $AnimatedSprite2D
@onready var endgame_ui := $endGameUI

func _ready() -> void:
	player_text_reference = $jogador_texto
	card_database_reference = preload("res://scripts/cards/card_database.gd")
	enemy_text_reference = $inimigo_texto
	player_hand_reference = $hand
	enemy_hand_reference = $enemy_hand
	deck_reference = $deck
	initial = 0
	table_limit = 21
	player_turn = 1
	player_life = 3
	enemy_life = 5
	bullets = 1
	initial_drag()

func initial_drag(): 
	initial = 1

func switch_turn():
	check_victory()
	if (player_turn or player_hand_reference.bust or player_hand_reference.stand) and not (enemy_hand_reference.bust or enemy_hand_reference.stand):
		player_turn = 0
		enemy_turn()
	else:
		player_turn = 1

func reset_game():
	if player_hand_reference:
		player_hand_reference.reset_hand()
	if enemy_hand_reference:
		enemy_hand_reference.reset_hand()
	
	player_turn = 1
	initial = 0
	deck_reference.reset_deck()
	
	if player_text_reference:
		player_text_reference.text = ""
	if enemy_text_reference:
		enemy_text_reference.text = ""
	
	initial_drag()
	
func russian_roulette(target_player: bool = true):
	var fire = randf() < (float(bullets) / 6.0)

	if fire == true:
		if target_player and player_life > 0:
			player_life -= 1
			player_text_reference.text = "[wave amp=50 freq=7] Você perdeu uma vida! [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			if player_life == 0:
				player_text_reference.text = "[wave amp=50 freq=7] Game Over! [/wave]"
				await get_tree().create_timer(1.5).timeout
				get_tree().paused = true
				endgame_ui.show()
				return
			
			reset_game()

		elif not target_player and enemy_life > 0:
			enemy_life -= 1
			enemy_text_reference.text = "[wave amp=50 freq=7] Deeler perdeu uma vida! [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			if enemy_life == 0:
				enemy_text_reference.text = "[wave amp=50 freq=7] Deeler foi eliminado! [/wave]"
				await get_tree().create_timer(1.5).timeout
				get_tree().paused = true
				endgame_ui.show()
				return
			
			reset_game()
	else:
		if target_player:
			player_text_reference.text = "[wave amp=50 freq=7] Você sobreviveu! [/wave]"
		else:
			enemy_text_reference.text = "[wave amp=50 freq=7] Deeler sobreviveu! [/wave]"
		await get_tree().create_timer(1.5).timeout
		reset_game()

func check_victory():
	if player_hand_reference.hand_sum > table_limit:
		player_hand_reference.bust = 1
		
		player_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		
	if enemy_hand_reference.hand_sum > table_limit:
		
		enemy_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		
		enemy_hand_reference.bust = 1
	
	if player_hand_reference.bust and not enemy_hand_reference.bust:
		print("Inimigo ganhou")
		
		enemy_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		
	if enemy_hand_reference.bust and not player_hand_reference.bust:
		print("Jogador ganhou")
		
		player_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
	
			
	
	if player_hand_reference.stand and enemy_hand_reference.stand:
		if player_hand_reference.hand_sum > enemy_hand_reference.hand_sum:
			print("Jogador ganhou")
			
			player_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			
		elif player_hand_reference.hand_sum < enemy_hand_reference.hand_sum:
			print("Inimigo ganhou")
			
			enemy_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			
			

		else:
			print("Empate")
			player_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			
			enemy_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			
	if enemy_hand_reference.bust and player_hand_reference.bust:
		print("Empate")
		
		player_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		
		enemy_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
			
		
func enemy_turn():

	
	if(not enemy_hand_reference.stand or not enemy_hand_reference.bust):
		if(player_hand_reference.bust):
			enemy_hand_reference.stand= 1
			enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			
		elif(player_hand_reference.stand):
			if(player_hand_reference.hand_sum<enemy_hand_reference.hand_sum):
				enemy_hand_reference.stand=1
				enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				
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
	else:
		switch_turn()
	
func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_return_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
