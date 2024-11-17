extends BaseMenu


func win() -> void:
	$Label.text = "You Won!"
	
func lose() -> void:
	$Label.text = "You Lost"
	


func _on_retry_pressed() -> void:
	menu_manager.play_pressed.emit(-1)
	menu_manager.change_menu(MenuManager.NONE)


func _on_main_pressed() -> void:
	menu_manager.change_menu(menu_manager.MAIN)
