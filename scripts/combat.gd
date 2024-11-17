class_name CombatManager extends Node2D

const PLAYER_WAIT_TIME: float = 2.0
const NOTE_SEPARATION: float = 192.0
const TIME_BETWEEN_NOTES: float = 1.0
const NOTE_SCENE := preload("res://scenes/note.tscn")

# Start with top e and then goes down
@export var string_nodes: Array[Node2D]

var active_input_handlers: Array[InputHandler] = []

var players_turn: bool = false
# Notes are stored in playing order. Used for spawning
# Notes that are next up are in the 0th index.
# The PackedInt32Array starts with the top e string and then goes down. -1 represents an empty note
var notes_to_spawn: Array[PackedInt32Array]

@onready var cutoff: Line2D = $Cutoff
@onready var timer_bar: ProgressBar = $TimerBar

#func _ready() -> void:
	#play_level(1)


func check_for_instantiated_notes() -> bool:
	for node in string_nodes:
		if node.get_child_count() > 0:
			return true
	return false
	
func set_to_first() -> void:
	notes_to_spawn = [
	[-1, -1, -1, -1, -1, 0],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 5],
	[-1, -1, -1, -1, -1, 0],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 6],[-1, -1, -1, -1, -1, 5],
	[-1, -1, -1, -1, -1, 0],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 5],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 0]
	]
	
func set_to_second() -> void:
	notes_to_spawn = [[-1, 2, 4, -1, -1, -1],[-1, -1, 2, 3, -1, -1],[-1, 1, 4, 3, 7, -1]]
	
	
func set_to_third() -> void:
	notes_to_spawn = [[-1, 2, 4, -1, -1, -1],[-1, -1, 2, 3, -1, -1],[-1, 1, 4, 3, 7, -1]]


func play_level(level: int) -> void:
	clear_notes()
	
	match level:
		1:
			set_to_first()
		2:
			set_to_second()
		3:
			set_to_third()
	
	play_current_notes()
	
	
func clear_notes() -> void:
	for string in string_nodes:
		for child in string.get_children():
			child.queue_free()
	

func play_current_notes() -> void:
	# While there are notes to be spawned or notes in the game		
	while len(notes_to_spawn) > 0 or check_for_instantiated_notes():
		# Spawn notes offscreen
		if len(notes_to_spawn) > 0:
			var next_notes := notes_to_spawn[0]
			
			for i in len(next_notes):
				if next_notes[i] != -1: # Spawn note
					var note_object := NOTE_SCENE.instantiate()
					note_object.text = str(next_notes[i])
					string_nodes[i].add_child(note_object)
					note_object.global_position = string_nodes[i].global_position
			# remove notes from queue
			notes_to_spawn.remove_at(0)
		# Move notes
		for string in string_nodes:
			for note in string.get_children():
				var tween := get_tree().create_tween()
				tween.bind_node(self)
				tween.set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
				tween.tween_property(note, "position", note.position - Vector2(NOTE_SEPARATION, 0), TIME_BETWEEN_NOTES)
		$NoteMoveTimer.start(TIME_BETWEEN_NOTES) 
		await $NoteMoveTimer.timeout
		
		# Check if note to play exists
		var note_to_play_exists: bool = false
		for string in string_nodes:
			for note in string.get_children():
				if note.global_position.x <= cutoff.global_position.x:
					note_to_play_exists = true
					break
			
		if note_to_play_exists:
			# Wait for player input
			var success := await get_player_input()
			# Process player input
			if success:
				print("win!")
			else:
				print("fail")
		# Delete notes
		for string in string_nodes:
			for note in string.get_children():
				if note.global_position.x <= cutoff.global_position.x:
					note.queue_free()
		
		
# This function will call the api and wait for player_wait_time
# It will return player's success
func get_player_input() -> bool:
	var handler: InputHandler = InputHandler.new()
	handler.timer = Timer.new()
	add_child(handler.timer)
	
	timer_bar.show()
	timer_bar.current_timer = handler.timer
	timer_bar.max_value = PLAYER_WAIT_TIME
	
	active_input_handlers.append(handler)
	api_call()
	call_deferred("timer_wait", handler)
	var success: bool = await handler.player_input_done
	
	# Clean up
	handler.timer.queue_free()
	active_input_handlers.remove_at(active_input_handlers.find(handler))
	timer_bar.hide()

	return success


func api_call() -> void:
	# Use api debug fake for now. See _input()
	pass


func api_debug_fake_callback(handler: InputHandler) -> void:
	handler.player_input_done.emit(true)


func _input(e: InputEvent) -> void:
	# For faking a correct note from api with "ui_accpet"
	for handler in active_input_handlers:
		if e.is_action_pressed("ui_accept"):
			api_debug_fake_callback(handler)


func timer_wait(handler: InputHandler) -> void:
	handler.timer.start(PLAYER_WAIT_TIME)
	await handler.timer.timeout
	handler.player_input_done.emit(false)


class InputHandler:
	var timer: Timer
	signal player_input_done(success: bool)
		



# The process
# Send the note we need to a function
# That function will tell the api to start recording for given interval
# Start a timer
# API will call one of our functions as soon as the first note is played
# If API does not return before the timer ends then return false
# If API returns false, return its false and stop the timer
