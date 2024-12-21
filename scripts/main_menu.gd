extends Control

func _on_quit_button_pressed() -> void:
	# Quit the game
	get_tree().quit()


func _on_options_button_pressed() -> void:
	# Add logic for an options menu
	print("Options Menu Placeholder")


func _on_start_button_pressed() -> void:
	# Play a transition animation or fade effect
	var transition = AnimatedSprite2D.new()
	# Add animation logic or instance a transition scene
	get_tree().change_scene_to_file("res://scenes/gameOfLife.tscn")
