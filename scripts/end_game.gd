extends Control

@onready var tela_vitoria := $"telaVitoria"
@onready var tela_derrota := $"telaDerrota"
@onready var blood_falling := $bloodFalling

func _ready() -> void:
	get_tree().paused = false
	print(UiActions.game_status)
	process_endgame()

func process_endgame():
	if UiActions.game_status == "victory!":
		tela_vitoria.show()
		tela_derrota.hide()

func _on_reiniciar_partida_pressed():
	blood_falling.show()
	blood_falling.play("blood_falling")
	await blood_falling.animation_finished
	UiActions._on_play_again_pressed()
func _on_retornar_menu_pressed():
	blood_falling.show()
	blood_falling.play("blood_falling")
	await blood_falling.animation_finished
	UiActions._on_return_to_menu_pressed()
