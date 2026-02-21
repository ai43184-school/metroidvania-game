extends Node2D

@onready var death_timer: Timer = $DeathTimer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		death_timer.start()
		GameManager.is_player_dead = true



func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
	GameManager.is_player_dead = false
