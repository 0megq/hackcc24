extends BaseMenu


func _on_play_pressed() -> void:
	menu_manager.play_pressed.emit()
	menu_manager.change_menu(MenuManager.NONE)


func _on_notes_pressed() -> void:
	menu_manager.change_menu(MenuManager.NOTES)


func _on_settings_pressed() -> void:
	menu_manager.change_menu(MenuManager.SETTINGS)


func _on_quit_pressed() -> void:
	get_tree().quit()
