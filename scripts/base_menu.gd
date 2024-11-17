class_name BaseMenu extends Control

var menu_manager: MenuManager

func _input(event: InputEvent) -> void:
	if !visible or !menu_manager:
		return
	
	if menu_manager.current_menu != menu_manager.MAIN and event.is_action_pressed("pause"):
		_back_input()


func _back_input() -> void:
	menu_manager.change_menu(menu_manager.previous_menu)
	get_viewport().set_input_as_handled()
