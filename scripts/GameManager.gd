extends Node

# Declaração dos novos sinais
signal game_ended(winner)
signal request_reset_hands

# Variáveis globais
var player_life = 3
var enemy_life = 5
var bullets = 6
var table_limit = 21

# Referências a Nodos que precisam ser passadas para as funções
var player_hand_reference
var enemy_hand_reference
var deck_reference
var player_text_reference
var enemy_text_reference
var endgame_ui

func russian_roulette(target_player: bool = true):
	var fire = randf() < (float(bullets) / 6.0)
	#dá erro se fechar o jogo antes de exibir os textos
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
			
			request_reset_hands.emit()

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
			
			request_reset_hands.emit()
	else:
		if target_player:
			player_text_reference.text = "[wave amp=50 freq=7] Você sobreviveu! [/wave]"
		else:
			enemy_text_reference.text = "[wave amp=50 freq=7] Deeler sobreviveu! [/wave]"
		await get_tree().create_timer(1.5).timeout
		request_reset_hands.emit()

func check_victory():
	if player_hand_reference.hand_sum > table_limit:
		player_hand_reference.bust = 1
		player_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		game_ended.emit("enemy")
		
	if enemy_hand_reference.hand_sum > table_limit:
		enemy_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		enemy_hand_reference.bust = 1
		game_ended.emit("player")
	
	if player_hand_reference.bust and not enemy_hand_reference.bust:
		print("Inimigo ganhou")
		request_reset_hands.emit()
		enemy_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		game_ended.emit("enemy")
		
	if enemy_hand_reference.bust and not player_hand_reference.bust:
		print("Jogador ganhou")
		request_reset_hands.emit()
		player_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		game_ended.emit("player")
	
	if player_hand_reference.stand and enemy_hand_reference.stand:
		if player_hand_reference.hand_sum > enemy_hand_reference.hand_sum:
			print("Jogador ganhou")
			request_reset_hands.emit()
			player_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			game_ended.emit("player")
			
		elif player_hand_reference.hand_sum < enemy_hand_reference.hand_sum:
			print("Inimigo ganhou")
			request_reset_hands.emit()
			enemy_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			game_ended.emit("enemy")
			
		else:
			print("Empate")
			player_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			request_reset_hands.emit()
			enemy_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			request_reset_hands.emit()

	if enemy_hand_reference.bust and player_hand_reference.bust:
		print("Empate")
		player_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		request_reset_hands.emit()
		enemy_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		request_reset_hands.emit()

func reset_game():
	# Este também pode emitir o sinal, já que também precisa resetar as mãos
	request_reset_hands.emit()
