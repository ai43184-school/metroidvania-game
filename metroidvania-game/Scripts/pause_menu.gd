extends Control


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
	

func _on_player_menu() -> void:
	get_tree().paused = true
	visible = true
