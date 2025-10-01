extends Node

@onready var endgame_ui := $endGameUI
@onready var pause_ui := $pauseUI

func show_end_game_ui():
	get_tree().paused = true
	endgame_ui.show()

func _on_play_again_pressed():
	get_tree().paused = true
	get_tree().reload_current_scene()

func _on_return_to_menu_pressed():
	get_tree().paused = true
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
