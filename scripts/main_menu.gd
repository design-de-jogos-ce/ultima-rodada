extends Control

func _on_button_iniciar_jogo_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_button_sair_jogo_pressed() -> void:
	get_tree().quit()
