extends BaseMenu


func win() -> void:
	$Label.text = "win!"
	
func lose() -> void:
	$Label.text = "lose :("
	


func _on_retry_pressed() -> void:
	menu_manager.change_menu(menu_manager.NONE)


func _on_main_pressed() -> void:
	menu_manager.change_menu(menu_manager.MAIN)
