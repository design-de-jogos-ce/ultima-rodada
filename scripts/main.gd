extends Node

const BULLET_PATH = "res://scenes/bullet.tscn"

#terminar a aposta



var player_turn
var deck_reference
var enemy_hand_reference
var player_hand_reference
var database_reference
var player_text_reference
var enemy_text_reference
var table_limit
var card_database_reference
var bullets_in_game_num
var bullets_in_game = []
var min_bet
var initial

@onready var animation := $AnimatedSprite2D
@onready var endgame_ui := $endGameUI

func _ready() -> void:
	min_bet = 1
	player_text_reference = $jogador_texto
	card_database_reference = preload("res://scripts/cards/card_database.gd")
	enemy_text_reference = $inimigo_texto
	player_hand_reference = $hand
	enemy_hand_reference = $enemy_hand
	deck_reference = $deck
	initial = 0
	bullets_in_game_num = 0
	table_limit = 21
	player_turn = 1
	initial_bullets()



func initial_bullets():
	for i in range(enemy_hand_reference.bullets_num):
		var bullet_scene = preload(BULLET_PATH)
		var bullet = bullet_scene.instantiate()
		bullet.get_node("Sprite2D").texture = load("res://assets/bala.png")
		
		var offset_x = i * 45 + randf_range(-10, 10)
		var offset_y = randf_range(-10, 10) 
		
		bullet.position = Vector2(230, 380) + Vector2(offset_x, offset_y)
		
		enemy_hand_reference.bullets.insert(0, bullet)
		$".".add_child(bullet)
		
	for i in range(player_hand_reference.bullets_num):
		var bullet_scene = preload(BULLET_PATH)
		var bullet = bullet_scene.instantiate()
		bullet.get_node("Sprite2D").texture = load("res://assets/bala.png")
		bullet.get_node("Area2D").collision_mask = 8
		var offset_x = i * 45 + randf_range(-10, 10)
		var offset_y = randf_range(-10, 10) 
		
		bullet.position = Vector2(230, 820) + Vector2(offset_x, offset_y)
		
		player_hand_reference.bullets.insert(0, bullet)
		$".".add_child(bullet)
		

func switch_turn():
	check_victory()
	if (player_turn or player_hand_reference.bust or player_hand_reference.stand) and not (enemy_hand_reference.bust or enemy_hand_reference.stand):
		player_turn = 0
		enemy_turn()
	else:
		player_hand_reference.can_bet=1
		player_turn =1
		
func pass_bullets(current_player):
	for i in range(bullets_in_game_num):
		var bullet = bullets_in_game[0]
		current_player.recive_bullet(bullet)
	bullets_in_game_num=0   
	
func check_victory():
	if player_hand_reference.hand_sum > table_limit and not player_hand_reference.bust:
		player_hand_reference.bust = 1
		player_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		russian_roulette(true)
		pass_bullets(enemy_hand_reference)
		return

	# --- Inimigo estourou ---
	if enemy_hand_reference.hand_sum > table_limit and not enemy_hand_reference.bust:
		enemy_hand_reference.bust = 1
		enemy_text_reference.text = "[wave amp=50 freq=7] Estourou [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		russian_roulette(false)
		pass_bullets(player_hand_reference)
		return

	# --- Jogador perde porque estourou ---
	if player_hand_reference.bust and not enemy_hand_reference.bust:
		print("Inimigo ganhou")
		enemy_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		russian_roulette(true)
		pass_bullets(enemy_hand_reference)
		return

	# --- Inimigo perde porque estourou ---
	if enemy_hand_reference.bust and not player_hand_reference.bust:
		print("Jogador ganhou")
		player_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		russian_roulette(false)
		pass_bullets(player_hand_reference)
		return

	# --- Ambos deram stand ---
	if player_hand_reference.stand and enemy_hand_reference.stand:
		if player_hand_reference.hand_sum > enemy_hand_reference.hand_sum:
			print("Jogador ganhou")
			player_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			russian_roulette(false)
			pass_bullets(player_hand_reference)
			return

		elif player_hand_reference.hand_sum < enemy_hand_reference.hand_sum:
			print("Inimigo ganhou")
			enemy_text_reference.text = "[wave amp=50 freq=7] Ganhou [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			russian_roulette(true)
			pass_bullets(enemy_hand_reference)
			return

		else:
			print("Empate")
			player_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""

			enemy_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			return

	# --- Ambos estouraram (empate) ---
	if enemy_hand_reference.bust and player_hand_reference.bust:
		print("Empate")
		player_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
		await get_tree().create_timer(1.5).timeout
		player_text_reference.text = ""
		
		enemy_text_reference.text = "[wave amp=50 freq=7] Empate [/wave]"
		await get_tree().create_timer(1.5).timeout
		enemy_text_reference.text = ""
		return

func russian_roulette(target_player: bool = true):
	var fire = randf() < (float(bullets_in_game_num) / 6.0)

	if fire == true:
		if target_player and player_hand_reference.life > 0:
			player_hand_reference.life -= 1
			player_text_reference.text = "[wave amp=50 freq=7] Você perdeu uma vida! [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			if player_hand_reference.life == 0:
				player_text_reference.text = "[wave amp=50 freq=7] Game Over! [/wave]"
				await get_tree().create_timer(1.5).timeout
				get_tree().paused = true
				endgame_ui.show()
				return
	
			reset_hands()

		elif not target_player and enemy_hand_reference.life > 0:
			enemy_hand_reference.life -= 1
			enemy_text_reference.text = "[wave amp=50 freq=7] Deeler perdeu uma vida! [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			if enemy_hand_reference.life == 0:
				enemy_text_reference.text = "[wave amp=50 freq=7] Deeler foi eliminado! [/wave]"
				await get_tree().create_timer(1.5).timeout
				get_tree().paused = true
				endgame_ui.show()
				return
			
			reset_hands()
	else:
		if target_player:
			player_text_reference.text = "[wave amp=50 freq=7] Você sobreviveu! [/wave]"
		else:
			enemy_text_reference.text = "[wave amp=50 freq=7] Deeler sobreviveu! [/wave]"
		await get_tree().create_timer(1.5).timeout
		reset_hands()
		
func enemy_turn():
	if enemy_hand_reference.can_bet == 1:
		enemy_hand_reference.bet_bullet()
	if(not enemy_hand_reference.stand or not enemy_hand_reference.bust):
		if(player_hand_reference.bust):
			enemy_hand_reference.stand= 1
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			switch_turn()
			
		elif(player_hand_reference.stand):
			if(player_hand_reference.hand_sum<enemy_hand_reference.hand_sum):
				enemy_hand_reference.stand=1
				enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				switch_turn()
				
			elif(player_hand_reference.hand_sum >= enemy_hand_reference.hand_sum and not( enemy_hand_reference.hand_sum ==21)):
				var count=0
				for i in range(deck_reference.deck.size()):
					if (enemy_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1])<=21:
						count+=1
				if count> 2*(deck_reference.deck.size()/3):
						animation.play("pede_carta")
						await get_tree().create_timer(1.5).timeout
						animation.play("idle")
						deck_reference.draw_card()
				else:
					enemy_hand_reference.stand=1
					enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
					await get_tree().create_timer(1.5).timeout
					enemy_text_reference.text = ""
					switch_turn()
		else:
			var count=0
			for i in range(deck_reference.deck.size()):
				if (player_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1])<=21:
					count+=1
			if count< 2*(deck_reference.deck.size()/3) and enemy_hand_reference.hand_sum>player_hand_reference.hand_sum:
				enemy_hand_reference.stand=1
				enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				switch_turn()
			else:
				count=0
				for i in range(deck_reference.deck.size()):
					if (enemy_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1])<=21:
						count+=1
				if count> 2*(deck_reference.deck.size()/3):
						animation.play("pede_carta")
						await get_tree().create_timer(1.5).timeout
						animation.play("idle")
						deck_reference.draw_card()
				else: 
					enemy_hand_reference.stand=1
					enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
					await get_tree().create_timer(1.5).timeout
					enemy_text_reference.text = ""
					switch_turn()

func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_return_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func reset_hands():
	deck_reference.deck = ["1_1","1_2","1_3","1_4","1_5","1_6","1_7",
			"1_8","1_9","1_10","1_11","1_12","1_13", 
			"2_1","2_2","2_3","2_4","2_5","2_6","2_7",
			"2_8","2_9","2_10","2_11","2_12","2_13", 
			"3_1","3_2","3_3","3_4","3_5","3_6","3_7",
			"3_8","3_9","3_10","3_11","3_12","3_13", 
			"4_1","4_2","4_3","4_4","4_5","4_6","4_7",
			"4_8","4_9","4_10","4_11","4_12","4_13"
			]
	for card in player_hand_reference.player_hand:
		if is_instance_valid(card):
			card.queue_free()
	player_hand_reference.player_hand.clear()
	player_hand_reference.hand_sum = 0
	player_hand_reference.bust = 0
	player_hand_reference.stand = 0
	player_hand_reference.win = 0
	player_hand_reference.double_down = 0
	player_hand_reference.surrender = 0
	player_hand_reference.bullets_bet = 0
	player_hand_reference.can_bet = 1
	player_hand_reference.hand_counter.text = "0"

	for card in enemy_hand_reference.player_hand:
		if is_instance_valid(card):
			card.queue_free()
	enemy_hand_reference.player_hand.clear()
	enemy_hand_reference.hand_sum = 0
	enemy_hand_reference.bust = 0
	enemy_hand_reference.stand = 0
	enemy_hand_reference.win = 0
	enemy_hand_reference.bullets_bet = 0
	enemy_hand_reference.revel = 0
	enemy_hand_reference.hand_counter.text = "0"
	enemy_hand_reference.can_bet = 1

	# Resetar textos
	player_text_reference.text = ""
	enemy_text_reference.text = ""
	initial = 1 if player_hand_reference.bullets_num == 0 else 0

	# Resetar turno
	player_turn = 1
