extends Control

@onready var music_player := $musicaTema
@onready var blood_falling := $bloodFalling
@onready var zuadaDeBala := $AudioStreamPlayer2D

func _ready():
	await music_player.ready
	music_player.playing()

func _on_button_iniciar_jogo_pressed() -> void:
	zuadaDeBala.play()
	blood_falling.show()
	blood_falling.play("blood_falling")
	await blood_falling.animation_finished
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
func _on_button_sair_jogo_pressed() -> void:
	get_tree().quit()
