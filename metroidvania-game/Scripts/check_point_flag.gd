extends Node2D

signal winscreen

@onready var tele_timer: Timer = $TeleportTimer


func _on_teleport_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		winscreen.emit()
		tele_timer.start()
