extends Node

var player_turn
var initial
var table_limit
var card_database_reference = preload("res://scripts/cards/card_database.gd")

@onready var drag := $AnimatedSprite2D
@onready var endgame_ui := $endGameUI

# Referências a Nodos
@onready var player_text_reference = $jogador_texto
@onready var enemy_text_reference = $inimigo_texto
@onready var player_hand_reference = $hand
@onready var enemy_hand_reference = $enemy_hand
@onready var deck_reference = $deck

func _ready() -> void:
	# Atribua as referências ao GameManager para que ele possa manipulá-las
	GameManager.player_hand_reference = player_hand_reference
	GameManager.enemy_hand_reference = enemy_hand_reference
	GameManager.deck_reference = deck_reference
	GameManager.player_text_reference = player_text_reference
	GameManager.enemy_text_reference = enemy_text_reference
	GameManager.endgame_ui = endgame_ui
	
	# Conecte os sinais do GameManager às funções locais
	GameManager.game_ended.connect(end_game)
	GameManager.request_reset_hands.connect(reset_hands)
	
	player_turn = 1
	initial = 0
	table_limit = 21
	initial_drag()

func initial_drag():
	initial = 1

func switch_turn():
	# Apenas uma chamada para a lógica de verificação
	GameManager.check_victory()
	if (player_turn or player_hand_reference.bust or player_hand_reference.stand) and not (enemy_hand_reference.bust or enemy_hand_reference.stand):
		player_turn = 0
		enemy_turn()
	else:
		player_turn = 1

func end_game(winner):
	# Esta função é chamada quando o sinal game_ended é emitido
	if winner == "player":
		russian_roulette(false)
	else:
		russian_roulette(true)

func russian_roulette(target_player: bool = true):
	# A função permanece aqui, pois lida com a lógica de vida e UI
	GameManager.russian_roulette(target_player)
	
func enemy_turn():
	# Esta função de IA permanece aqui para lidar com a interação da cena
	if(not enemy_hand_reference.stand or not enemy_hand_reference.bust):
		if(player_hand_reference.bust):
			enemy_hand_reference.stand = 1
			enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
			await get_tree().create_timer(1.5).timeout
			enemy_text_reference.text = ""
			switch_turn()
			
		elif(player_hand_reference.stand):
			if(player_hand_reference.hand_sum < enemy_hand_reference.hand_sum):
				enemy_hand_reference.stand = 1
				enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				switch_turn()
				
			elif(player_hand_reference.hand_sum >= enemy_hand_reference.hand_sum and not( enemy_hand_reference.hand_sum ==21)):
				var count=0
				for i in range(deck_reference.deck.size()):
					if (enemy_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1]) <= 21:
						count+=1
				if count > 2*(deck_reference.deck.size()/3):
					drag.play("pede_carta")
					await get_tree().create_timer(1.5).timeout
					drag.play("idle")
					deck_reference.draw_card()
				else:
					enemy_hand_reference.stand = 1
					enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
					await get_tree().create_timer(1.5).timeout
					enemy_text_reference.text = ""
					switch_turn()
		else:
			var count=0
			for i in range(deck_reference.deck.size()):
				if (player_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1]) <= 21:
					count+=1
			if count < 2*(deck_reference.deck.size()/3):
				enemy_hand_reference.stand = 1
				enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
				await get_tree().create_timer(1.5).timeout
				enemy_text_reference.text = ""
				switch_turn()
			else:
				count=0
				for i in range(deck_reference.deck.size()):
					if (enemy_hand_reference.hand_sum+card_database_reference.CARDS[deck_reference.deck[i]][1]) <= 21:
						count+=1
				if count > 2*(deck_reference.deck.size()/3):
					drag.play("pede_carta")
					await get_tree().create_timer(1.5).timeout
					drag.play("idle")
					deck_reference.draw_card()
				else: 
					enemy_hand_reference.stand = 1
					enemy_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
					await get_tree().create_timer(1.5).timeout
					enemy_text_reference.text = ""
					switch_turn()

func reset_hands():
	# Esta função permanece aqui, pois lida diretamente com os nós da cena
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
	player_hand_reference.hand_counter.text = "0"

	for card in enemy_hand_reference.player_hand:
		if is_instance_valid(card):
			card.queue_free()
	enemy_hand_reference.player_hand.clear()
	enemy_hand_reference.hand_sum = 0
	enemy_hand_reference.bust = 0
	enemy_hand_reference.stand = 0
	enemy_hand_reference.win = 0
	enemy_hand_reference.revel = 0
	enemy_hand_reference.hand_counter.text = "0"

	player_text_reference.text = ""
	enemy_text_reference.text = ""

	player_turn = 1

func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_return_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
