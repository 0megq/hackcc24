extends Node


func _on_menu_manager_play_pressed() -> void:
	$Combat.process_mode = Node.PROCESS_MODE_INHERIT
	$Combat.play_level(1)


func _on_menu_manager_menu_opened() -> void:
	$Combat.process_mode = Node.PROCESS_MODE_DISABLED


func _on_menu_manager_menu_closed() -> void:
	$Combat.process_mode = Node.PROCESS_MODE_INHERIT
