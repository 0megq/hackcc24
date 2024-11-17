extends Node

@onready var menu_manager: MenuManager = $MenuManager
@onready var combat: CombatManager = $Combat

func _on_menu_manager_play_pressed() -> void:
	combat.process_mode = Node.PROCESS_MODE_INHERIT
	combat.play_level(1)


func _on_menu_manager_menu_opened() -> void:
	combat.process_mode = Node.PROCESS_MODE_DISABLED


func _on_menu_manager_menu_closed() -> void:
	combat.process_mode = Node.PROCESS_MODE_INHERIT


func _on_combat_player_lost() -> void:
	menu_manager.lose()


func _on_combat_player_won() -> void:
	menu_manager.win()
