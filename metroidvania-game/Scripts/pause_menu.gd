extends Control

var pause_menu_open = false

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
	

func _physics_process(delta: float) -> void:
	pause_menu_open = GameManager.menu_open
	if pause_menu_open:
		_on_player_menu()

func _on_player_menu() -> void:
	pause_menu_open = false
	GameManager.menu_open = false
	get_tree().paused = true
	visible = true
