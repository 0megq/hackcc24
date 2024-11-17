extends Node

const COMBAT_SCENE := preload("res://scenes/combat.tscn")

const BLUR_FADE_TIME := 1.0

@onready var menu_manager: MenuManager = $MenuManager
var combat: CombatManager = null
var current_level: int = 1


func restart_combat() -> void:
	if combat:
		combat.queue_free()
	combat = COMBAT_SCENE.instantiate()
	add_child(combat)
	combat.connect("player_won", _on_combat_player_won)
	combat.connect("player_lost", _on_combat_player_lost)
	

func _on_menu_manager_play_pressed(level: int) -> void:
	if level != -1:
		current_level = level
	restart_combat()
	combat.process_mode = Node.PROCESS_MODE_INHERIT
	combat.play_level(current_level)

func _on_menu_manager_menu_opened() -> void:
	if combat:
		combat.process_mode = Node.PROCESS_MODE_DISABLED


func _on_menu_manager_menu_closed() -> void:
	if combat:
		combat.process_mode = Node.PROCESS_MODE_INHERIT
	

func _on_combat_player_lost() -> void:
	menu_manager.lose()


func _on_combat_player_won() -> void:
	menu_manager.win()
