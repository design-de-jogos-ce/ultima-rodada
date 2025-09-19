extends Node

var player_turn
var deck_reference
var enemy_hand_reference
var player_hand_reference
var database_reference
var player_text_reference
var enemy_text_reference
var table_limit
var initial
var player_life
var enemy_life
var bullets

@onready var drag := $AnimatedSprite2D
@onready var endgame_ui := $endGameUI

func _ready() -> void:
	player_text_reference = $jogador_texto
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
	
	await get_tree().create_timer(1.5).timeout
	for i in range((((table_limit-1)/10)*2)):
		deck_reference.draw_card()
		await get_tree().create_timer(0.5).timeout
		player_turn = 1 - player_turn
	initial = 1

func switch_turn():
	await get_tree().create_timer(1.0).timeout
	for i in range(enemy_hand_reference.player_hand.size()):
		enemy_hand_reference.player_hand[i].get_node("card-sprite").texture = load(enemy_hand_reference.player_hand[i].image_path) 
	player_turn = 0
	enemy_turn()

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
	if player_hand_reference.surrender:
		player_hand_reference.bust = 1
		player_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.0).timeout
		russian_roulette(true)
		

	if not player_hand_reference.stand and not player_hand_reference.bust:
		if player_hand_reference.hand_sum > table_limit:
			player_hand_reference.bust = 1
			player_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			print("Jogador estourou")
			switch_turn()
			await get_tree().create_timer(1.0).timeout
			russian_roulette(true)
			

		if player_hand_reference.hand_sum == table_limit:
			player_hand_reference.win = 1
			await get_tree().create_timer(1.0).timeout
			player_text_reference.text = "[wave amp=50 freq=7] Vitória! [/wave]"
			russian_roulette(false)
			

	if not enemy_hand_reference.stand and not enemy_hand_reference.bust:
		if enemy_hand_reference.hand_sum > table_limit:
			enemy_hand_reference.bust = 1
			await get_tree().create_timer(1.0).timeout
			print("Deeler estourou. Vitória!")
			russian_roulette(false)
			

		if enemy_hand_reference.hand_sum == table_limit:
			enemy_hand_reference.win = 1
			print("Deeler venceu.")
			russian_roulette(true)
			
	
	if player_hand_reference.win and enemy_hand_reference.win:
		print("Empataram ganhando")
		russian_roulette(true)
		
	else:
		if player_hand_reference.win:
			print("Jogador ganhou")
			russian_roulette(false)
			

		elif enemy_hand_reference.win:
			print("Deeler ganhou")
			russian_roulette(true)
			
			
	if player_hand_reference.bust and enemy_hand_reference.bust:
		print("Empataram estourando")
	await get_tree().create_timer(3.0).timeout
	
	if player_hand_reference.stand == 1 and enemy_hand_reference.stand == 1:
		if player_hand_reference.hand_sum >= enemy_hand_reference.hand_sum:
			player_text_reference.text = "[wave amp=50 freq=7] Vitória! [/wave]"
			await get_tree().create_timer(1.0).timeout
			russian_roulette(false)
			
		else:
			player_text_reference.text = "[wave amp=50 freq=7] Derrota! [/wave]"
			await get_tree().create_timer(1.0).timeout
			russian_roulette(true)
			
	
func enemy_turn():
	
	if enemy_hand_reference.hand_sum <= 15:
		deck_reference.draw_card()
	else:
		enemy_hand_reference.stand = 1
		check_victory()

func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_return_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
