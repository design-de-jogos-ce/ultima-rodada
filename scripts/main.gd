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
	initial_drag()

func initial_drag(): 
	initial = 1

func switch_turn():
	check_victory()
	if (player_turn or player_hand_reference.bust or player_hand_reference.stand) and not (enemy_hand_reference.bust or enemy_hand_reference.stand):
		player_turn = 0
		enemy_turn()
	else:
		player_turn =1
	
	
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
	await get_tree().create_timer(1.0).timeout
	deck_reference.draw_card()
	
func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_return_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
