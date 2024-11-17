extends Node

const BLUR_FADE_TIME := 1.0

@onready var menu_manager: MenuManager = $MenuManager
@onready var combat: CombatManager = $Combat

func _on_menu_manager_play_pressed() -> void:
	combat.process_mode = Node.PROCESS_MODE_INHERIT
	combat.play_level(4)


func blur() -> void:
	if $BlurredBackground.modulate != Color.WHITE or $AnimationPlayer.assigned_animation != "blur":
		$AnimationPlayer.play("blur")
	
	
func unblur() -> void:
	if $BlurredBackground.modulate != Color.TRANSPARENT or $AnimationPlayer.assigned_animation != "unblur":
		$AnimationPlayer.play("unblur")


func _on_menu_manager_menu_opened() -> void:
	combat.process_mode = Node.PROCESS_MODE_DISABLED


func _on_menu_manager_menu_closed() -> void:
	combat.process_mode = Node.PROCESS_MODE_INHERIT
	

func _on_combat_player_lost() -> void:
	menu_manager.lose()


func _on_combat_player_won() -> void:
	menu_manager.win()
