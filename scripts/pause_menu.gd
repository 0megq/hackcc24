extends BaseMenu

func _back_input() -> void:
	menu_manager.change_menu(menu_manager.NONE)
	get_viewport().set_input_as_handled()


func _on_main_pressed() -> void:
	menu_manager.change_menu(menu_manager.MAIN)


func _on_resume_pressed() -> void:
	menu_manager.change_menu(menu_manager.NONE)
