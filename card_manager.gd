extends Node2D

const COLLISION_MASK = 1
const COLLISION_MASK_SLOT = 2
const DEFAULT_SPEED=0.1

var card_dragged
var windows_size
var hover_on_card
var player_hand_reference
var card_slot_reference
var hand_reference


func _ready() -> void:
	windows_size = get_viewport_rect().size #atribui o tamanho da tela para essa variável
	hand_reference = $"../hand"
	player_hand_reference = $"../hand"
	card_slot_reference = $"../card_slot16"
	$"../input_manager".connect("left_mouse_button_released",on_left_click_released)
	
func _process(delta: float) -> void:
	#função chamada a cada frame
	if card_dragged: #se estou clocando em uma carta, ela fica segurada e sendo carregada acompanhando o mouse
		var mouse_pos = get_global_mouse_position()  
		card_dragged.position= mouse_pos
		card_dragged.position = Vector2(clamp(mouse_pos.x,0,windows_size.x),clamp(mouse_pos.y,0,windows_size.y))

func connect_card_signals(card):
	card.connect("hover_on", on_hover_over_card)
	card.connect("hover_off", on_hover_off_card)

func on_left_click_released():
	if card_dragged:
		finish_drag()

func on_hover_over_card(card):
	if !hover_on_card:
		hover_on_card= true
		highlight_card(card,true)
	
func on_hover_off_card(card):
	if !card_dragged:
		highlight_card(card,false)
		var new_hover_on_card = raycast_check_for_card()
		if new_hover_on_card:
			highlight_card(new_hover_on_card, true)
		else:
			hover_on_card = false

func highlight_card(card, hover_on):
	
	if hover_on:
		card.scale.x += 0.05
		card.scale.y += 0.05
		card.z_index=2
	else:
		card.scale.x -= 0.05
		card.scale.y -= 0.05
		
		card.z_index=1
			
func raycast_check_for_card(): 
	var space_state = get_world_2d().direct_space_state 
	var parameters = PhysicsPointQueryParameters2D.new() 
	parameters.position = get_global_mouse_position() 
	parameters.collide_with_areas = true 
	parameters.collision_mask = COLLISION_MASK 
	var result = space_state.intersect_point(parameters) 
	if result.size() > 0:
		#return result[0].collider.get_parent() 
		return get_card_with_highest_z(result)
	return null

func raycast_check_for_card_slot(): 
	var space_state = get_world_2d().direct_space_state 
	var parameters = PhysicsPointQueryParameters2D.new() 
	parameters.position = get_global_mouse_position() 
	parameters.collide_with_areas = true 
	parameters.collision_mask = COLLISION_MASK_SLOT
	var result = space_state.intersect_point(parameters) 
	if result.size() > 0:
		#return result[0].collider.get_parent() 
		return result[0].collider.get_parent() 
	return null
	
func get_card_with_highest_z(cards):
	var highest_card = cards[0].collider.get_parent() 
	var highest_z = highest_card.z_index
	
	for i in range(1, cards.size()):
		var current_cards = cards[i].collider.get_parent() 
		if current_cards.z_index > highest_z:
			highest_card = cards[i].collider.get_parent() 
			highest_z = highest_card.z_index
	return highest_card
	
func start_drag( card ):
	return
	card_dragged = card
	card.scale = Vector2(0.8,0.8)
	
func finish_drag():
	card_dragged.scale = Vector2(0.8,0.8)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found:
		player_hand_reference.remove_card_from_hand(card_dragged)
		card_dragged.position = card_slot_found.position
		card_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_reference.add_card_to_slot(card_dragged)
	else:
		player_hand_reference.add_card_to_hand(card_dragged,DEFAULT_SPEED)
	card_dragged = null
