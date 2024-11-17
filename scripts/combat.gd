class_name CombatManager extends Node2D

const PLAYER_WAIT_TIME: float = 2.0
const NOTE_SEPARATION: float = 192.0
const TIME_BETWEEN_NOTES: float = 3.0
const NOTE_SCENE := preload("res://scenes/note.tscn")

# First index will select a string then second index will select a fret on that string
var NOTE_FREQUENCYS: Array[PackedInt32Array] = [
	[330, 349, 370, 392, 415, 440, 466, 494, 523, 554, 587, 622, 659], # Top E
	[110, 117, 124, 131, 139, 147, 156, 165, 175, 185, 196, 208, 220], # A
	[147, 156, 165, 175, 185, 196, 208, 220, 233, 247, 262, 278, 294], # D
	[196, 208, 220, 233, 247, 262, 278, 294, 311, 330, 349, 370, 392], # G	
	[247, 262, 278, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494], # B
	[82,  87,  93,  98, 104, 110, 117, 124, 131, 139, 147, 156, 165], # Bottom E
	]

# Start with top e and then goes down
@export var string_nodes: Array[Node2D]

var active_input_handlers: Array[InputHandler] = []

var players_turn: bool = false
# Notes are stored in playing order. Used for spawning
# Notes that are next up are in the 0th index.
# The PackedInt32Array starts with the top e string and then goes down. -1 represents an empty note
var notes_to_spawn: Array[PackedInt32Array]

var threads: Array[Thread]

@onready var cutoff: Line2D = $Cutoff
@onready var timer_bar: ProgressBar = $TimerBar
@onready var note_move_timer: Timer = $NoteMoveTimer
@onready var frequency_py: Node = $FrequencyMagic.get_pyscript()


func _process(delta: float) -> void:
	for thread in threads:
		if !thread.is_alive():
			thread.wait_to_finish()
			threads.remove_at(threads.find(thread))


func check_for_instantiated_notes() -> bool:
	for node in string_nodes:
		if node.get_child_count() > 0:
			return true
	return false
	
	
func set_to_first() -> void:
	notes_to_spawn = [
	[-1, -1, -1, -1, -1, 0],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 5],
	[-1, -1, -1, -1, -1, 0],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 6],[-1, -1, -1, -1, -1, 5],
	[-1, -1, -1, -1, -1, 0],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 5],[-1, -1, -1, -1, -1, 3],[-1, -1, -1, -1, -1, 0],
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
		
		note_move_timer.call_deferred("start",TIME_BETWEEN_NOTES) 
		await note_move_timer.timeout
		
		# Check if note to play exists
		var note_to_play_exists: bool = false
		var note_freq: int
		for string_num in len(string_nodes):
			var string := string_nodes[string_num]
			for note in string.get_children():
				if note.global_position.x <= cutoff.global_position.x:
					note_to_play_exists = true
					note_freq = NOTE_FREQUENCYS[string_num][int(note.text)]
					#print(string_num, " ", int(note.text))
					break
			
		if note_to_play_exists:
			# Activat player_input
			var handler: InputHandler = InputHandler.new()
			handler.timer = Timer.new()
			add_child(handler.timer)
			#print(note_freq)
			activate_player_input(handler, note_freq)
			
			# Receive player input
			while !handler.player_input_received:
				await get_tree().create_timer(0.01).timeout
			var success: bool = await handler.player_success
			
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
func activate_player_input(handler: InputHandler, note_freq: int) -> void:
	timer_bar.show()
	timer_bar.current_timer = handler.timer
	timer_bar.max_value = PLAYER_WAIT_TIME
	
	active_input_handlers.append(handler)
	var thread: Thread = Thread.new()
	threads.append(thread)
	thread.start(api_call.bindv([handler, note_freq]))
	
	timer_wait(handler)
	handler.connect("internal", test)
	
	
func test(success: bool, handler: InputHandler) -> void:
	if handler.timer != null and handler.timer.is_node_ready():
		handler.timer.queue_free()
	var handler_index := active_input_handlers.find(handler)
	if handler_index >= 0:
		active_input_handlers.remove_at(handler_index)
		
	timer_bar.call_deferred("hide")
	handler.player_success = success
	handler.player_input_received = true
	

func api_call(handler: InputHandler, freq: int) -> void:
	# Use api debug fake for now. See _input()
	var value: bool = await frequency_py.isLiveFreqCorrect(freq)
	handler.internal.emit(value, handler)
	

func api_debug_fake_callback(handler: InputHandler) -> void:
	handler.internal.emit(true, handler)


func _input(e: InputEvent) -> void:
	# For faking a correct note from api with "ui_accpet"
	for handler in active_input_handlers:
		if e.is_action_pressed("ui_accept"):
			api_debug_fake_callback(handler)


func timer_wait(handler: InputHandler) -> void:
	handler.timer.start(PLAYER_WAIT_TIME)
	await handler.timer.timeout
	handler.internal.emit(false, handler)

class InputHandler:
	var timer: Timer
	var player_input_received: bool = false
	var player_success: bool = false
	signal internal(success: bool, handler: InputHandler)
		



# The process
# Send the note we need to a function
# That function will tell the api to start recording for given interval
# Start a timer
# API will call one of our functions as soon as the first note is played
# If API does not return before the timer ends then return false
# If API returns false, return its false and stop the timer
