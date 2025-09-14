extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK = 1
const COLLISION_MASK_DACK = 4

var card_manager_reference
var deck_reference
var deeler_reference
var player_hand_reference
var player_text_reference

@onready var endgame_ui := $"../endGameUI"

func _ready() -> void:
	player_hand_reference = $"../hand"
	player_text_reference= $"../jogador_texto"
	card_manager_reference = $"../card-manager"
	deck_reference = $"../deck"
	deeler_reference = $".."

func _input(event) -> void:
	
	if event.is_action_pressed("pausa_jogo"):
		if not event.is_echo():
			toggle_pause_menu()
			return
	
	if not get_tree().paused:
		if event.is_action_pressed("dobra_aposta") and deeler_reference.initial and deeler_reference.player_turn and not player_hand_reference.double_down:
			player_hand_reference._double_down()
		
		if event.is_action_pressed("passa_vez") and deeler_reference.initial and deeler_reference.player_turn and not player_hand_reference.double_down:
			player_hand_reference.stand = 1
			deeler_reference.switch_turn()
			player_text_reference.text = "[wave amp=50 freq=7] Passou [/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			print("Player passou")
		
		if event.is_action_pressed("ui_accept") and deeler_reference.initial and deeler_reference.player_turn and not player_hand_reference.surrender:
			player_hand_reference._surrender()

		if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
			if event.pressed:
				emit_signal("left_mouse_button_clicked")
				raycast_at_cursor()
			else:
				emit_signal("left_mouse_button_released")

func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state 
	var parameters = PhysicsPointQueryParameters2D.new() 
	parameters.position = get_global_mouse_position() 
	parameters.collide_with_areas = true 
	var result = space_state.intersect_point(parameters) 
	if result.size():
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK:
			var card_found =  result[0].collider.get_parent() 
			if card_found :
				card_manager_reference.start_drag(card_found)
		elif result_collision_mask == COLLISION_MASK_DACK and deeler_reference.player_turn and not player_hand_reference.stand and deeler_reference.initial and not player_hand_reference.bust:
			deck_reference.draw_card()
			
func toggle_pause_menu():
	if get_tree().paused:
		get_tree().paused = false
		endgame_ui.hide()
	else:
		get_tree().paused = true
		endgame_ui.show()
