extends Node2D


func _on_check_point_flag_winscreen() -> void:
	GameManager.unlock_jump = true
