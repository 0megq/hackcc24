extends BaseMenu


func win() -> void:
	$Label.text = "You  Won!"
	$Victory.play(1.2)
	
func lose() -> void:
	$Label.text = "You  Lost"
	$Defeat.play()


func _on_retry_pressed() -> void:
	menu_manager.play_pressed.emit(-1)
	menu_manager.change_menu(MenuManager.NONE)


func _on_main_pressed() -> void:
	menu_manager.change_menu(menu_manager.MAIN)
