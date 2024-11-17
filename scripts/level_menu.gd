extends BaseMenu


func _on_1_pressed() -> void:
	menu_manager.play_pressed.emit(1)
	menu_manager.change_menu(menu_manager.NONE)


func _on_2_pressed() -> void:
	menu_manager.play_pressed.emit(2)
	menu_manager.change_menu(menu_manager.NONE)


func _on_3_pressed() -> void:
	menu_manager.play_pressed.emit(3)
	menu_manager.change_menu(menu_manager.NONE)


func _on_4_pressed() -> void:
	menu_manager.play_pressed.emit(4)
	menu_manager.change_menu(menu_manager.NONE)
