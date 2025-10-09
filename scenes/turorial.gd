extends Node2D
func tutorial():
	await get_tree().create_timer(0.5).timeout
	$Label.visible = true
	await get_tree().create_timer(5).timeout
	$Label.visible = false
	await get_tree().create_timer(0.5).timeout
	$Label2.visible = true
	await get_tree().create_timer(5).timeout
	$Label2.visible = false
	await get_tree().create_timer(0.5).timeout
	$Label3.visible = true
	await get_tree().create_timer(5).timeout
	$Label3.visible = false
	await get_tree().create_timer(0.5).timeout
	$Label4.visible = true
	await get_tree().create_timer(5).timeout
	$Label4.visible = false

	await get_tree().create_timer(0.5).timeout
	$Label9.visible = true
	await get_tree().create_timer(5).timeout
	$Label9.visible = false

	await get_tree().create_timer(0.5).timeout
	$Label5.visible = true
	await get_tree().create_timer(5).timeout
	$Label5.visible = false
	await get_tree().create_timer(0.5).timeout
	$Label6.visible = true
	await get_tree().create_timer(5).timeout
	$Label6.visible = false
	await get_tree().create_timer(0.5).timeout
	$Label7.visible = true
	await get_tree().create_timer(5).timeout
	$Label7.visible = false
	await get_tree().create_timer(0.5).timeout
	$Label8.visible = true
	await get_tree().create_timer(5).timeout
	$Label8.visible = false
