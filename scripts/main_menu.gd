extends BaseMenu


func _on_play_pressed() -> void:
	menu_manager.change_menu(MenuManager.LEVEL_SELECT)


func _on_quit_pressed() -> void:
	get_tree().quit()
