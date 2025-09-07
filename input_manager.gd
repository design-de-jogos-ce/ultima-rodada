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

func _ready() -> void:
	player_hand_reference = $"../hand"
	player_text_reference= $"../jogador_texto"
	card_manager_reference = $"../card-manager"
	deck_reference = $"../deck"
	deeler_reference = $".."

func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			player_hand_reference.player_pass = 1
			
			player_text_reference.text = "[wave amp=50 freq=7]Você passou[/wave]"
			await get_tree().create_timer(1.5).timeout
			player_text_reference.text = ""
			
			print("Player passou")
			deeler_reference.switch_turn()
		else:
			emit_signal("left_mouse_button_released")

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
		elif result_collision_mask == COLLISION_MASK_DACK and deeler_reference.player_turn and not player_hand_reference.player_pass:
			deck_reference.draw_card()
