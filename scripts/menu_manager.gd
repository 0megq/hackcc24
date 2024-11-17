class_name MenuManager extends CanvasLayer

# Originate in this class
signal menu_opened
signal menu_closed

# Originate in one of the menus that are a child of this
signal play_pressed(level: int)

enum {
	MAIN,
	LEVEL_SELECT,
	PAUSE,
	RESULTS,
	NONE,
}

var current_menu: int = NONE
var previous_menu: int = NONE

@onready var main_menu: Control = $MainMenu
@onready var settings_menu: Control = $SettingsMenu
@onready var pause_menu: Control = $PauseMenu
@onready var results_menu: Control = $ResultsMenu
@onready var main: Node = $".."
@onready var level_menu: Control = $LevelMenu


func _ready() -> void:
	show()
	
	for child in get_children():
		child.menu_manager = self
	
	change_menu.call_deferred(MAIN)
	

func change_menu(new_menu: int) -> void:
	hide_all_menus()
	
	# show new menu
	match new_menu:
		MAIN:
			main_menu.show()

		PAUSE:
			pause_menu.show()

		RESULTS:
			results_menu.show()
		LEVEL_SELECT:
			level_menu.show()
	
	# emit signals
	if new_menu != NONE and current_menu == NONE:
		menu_opened.emit()
	elif new_menu == NONE and current_menu != NONE:
		menu_closed.emit()
		
	# set menus
	previous_menu = current_menu
	current_menu = new_menu


func hide_all_menus() -> void:
	for child in get_children():
		child.hide()
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_menu == NONE:
			change_menu(PAUSE)


func win() -> void:
	results_menu.win()
	change_menu(RESULTS)
	
	
func lose() -> void:
	results_menu.lose()
	change_menu(RESULTS)
