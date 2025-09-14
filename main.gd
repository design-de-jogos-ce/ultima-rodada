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
	
	await get_tree().create_timer(3).timeout
	for i in range((((table_limit-1)/10)*2)):
		deck_reference.draw_card()
		await get_tree().create_timer(1.0).timeout
		player_turn = 1 - player_turn
	initial = 1

func switch_turn():
	await get_tree().create_timer(1.0).timeout
	for i in range(enemy_hand_reference.player_hand.size()):
		enemy_hand_reference.player_hand[i].get_node("card-sprite").texture = load(enemy_hand_reference.player_hand[i].image_path) 
	player_turn = 0
	enemy_turn()
	
func check_victory():
	if player_hand_reference.surrender:
		pass
	
	if not player_hand_reference.stand and not player_hand_reference.bust:
		if player_hand_reference.hand_sum > table_limit:
			player_hand_reference.bust = 1
			player_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			print("Jogador estourou")
			switch_turn()

		if player_hand_reference.hand_sum == table_limit:
			player_hand_reference.win = 1
			
	if not enemy_hand_reference.stand and not enemy_hand_reference.bust:
		if enemy_hand_reference.hand_sum > table_limit:
			enemy_hand_reference.bust = 1
			print("Deeler estourou")

		if enemy_hand_reference.hand_sum == table_limit:
			enemy_hand_reference.win = 1
	
	if player_hand_reference.win and enemy_hand_reference.win:
		print("Empataram ganhando")
	else:
		if player_hand_reference.win:
			print("Jogador ganhou")

		elif enemy_hand_reference.win:
			print("Deeler ganhou")
			
	if player_hand_reference.bust and enemy_hand_reference.bust:
		print("Empararam estourando")
	await get_tree().create_timer(3.0).timeout
	display_end_game_ui()
	
func enemy_turn():
	
	deck_reference.draw_card()
	pass
	
func display_end_game_ui():
	endgame_ui.show()
	
func _on_play_again_pressed():
	get_tree().reload_current_scene()
	
func _on_return_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
