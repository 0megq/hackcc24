extends BaseMenu


func _on_back_pressed() -> void:
	menu_manager.change_menu(menu_manager.previous_menu)
